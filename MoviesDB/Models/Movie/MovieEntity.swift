//
//  MovieEntity.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 10.12.2023.
//

import CoreData

@objc(MovieEntity)
public class MovieEntity: NSManagedObject {

}

extension MovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var id: Int
    @NSManaged public var title: String
    @NSManaged public var imagePath: String?
    @NSManaged public var rating: Double

}
