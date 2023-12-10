//
//  ImageCache.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 10.12.2023.
//

import UIKit

protocol ImageCacheProtocol: AnyObject {
    func image(for name: String) -> UIImage?
    func insertImage(_ image: UIImage?, for name: String)
    func removeImage(for name: String)
    func removeAllImages()
    subscript(_ key: String) -> UIImage? { get set }
}

final class ImageCache {

    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = config.countLimit
        return cache
    }()

    private lazy var decodedImageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.totalCostLimit = config.memoryLimit
        return cache
    }()
    private let lock = NSLock()
    private let config: Config

    struct Config {
        let countLimit: Int
        let memoryLimit: Int

        static let defaultConfig = Config(countLimit: 100, memoryLimit: 1024 * 1024 * 100) // 100 MB
    }

    init(config: Config = Config.defaultConfig) {
        self.config = config
    }
}

extension ImageCache: ImageCacheProtocol {
    func insertImage(_ image: UIImage?, for name: String) {
        guard let image = image else { return removeImage(for: name) }
        let decodedImage = image.decodedImage()

        lock.lock(); defer { lock.unlock() }
        imageCache.setObject(decodedImage, forKey: name as AnyObject)
        decodedImageCache.setObject(image as AnyObject, forKey: name as AnyObject, cost: decodedImage.diskSize)
    }

    func removeImage(for name: String) {
        lock.lock(); defer { lock.unlock() }
        imageCache.removeObject(forKey: name as AnyObject)
        decodedImageCache.removeObject(forKey: name as AnyObject)
    }
    
    func removeAllImages() {
        lock.lock(); defer { lock.unlock() }
        imageCache.removeAllObjects()
        decodedImageCache.removeAllObjects()
    }
    
    func image(for name: String) -> UIImage? {
        lock.lock(); defer { lock.unlock() }
        // the best case scenario -> there is a decoded image
        if let decodedImage = decodedImageCache.object(forKey: name as AnyObject) as? UIImage {
            return decodedImage
        }
        // search for image data
        if let image = imageCache.object(forKey: name as AnyObject) as? UIImage {
            let decodedImage = image.decodedImage()
            decodedImageCache.setObject(image as AnyObject, forKey: name as AnyObject, cost: decodedImage.diskSize)
            return decodedImage
        }
        return nil
    }
    
    subscript(_ key: String) -> UIImage? {
        get {
            return image(for: key)
        }
        set {
            return insertImage(newValue, for: key)
        }
    }
}
