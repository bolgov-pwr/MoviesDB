//
//  MoviesMemoryCacheProvider.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 10.12.2023.
//

import UIKit

protocol MoviesMemoryCacheProviderProtocol {
    func loadImage(from path: String) -> UIImage?
    func saveImage(_ image: UIImage?, from path: String)
}

final class MoviesMemoryCacheProvider: MoviesMemoryCacheProviderProtocol {
    
    private let imageCache: ImageCacheProtocol
    
    init(imageCache: ImageCacheProtocol) {
        self.imageCache = imageCache
    }
    
    func loadImage(from path: String) -> UIImage? {
        return imageCache[path]
    }
    
    func saveImage(_ image: UIImage?, from path: String) {
        imageCache[path] = image
    }
}
