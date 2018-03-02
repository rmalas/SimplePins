//
//  Annotation+CoreDataProperties.swift
//  Roman_Malasniak_SimplePins
//
//  Created by Roman Malasnyak on 3/1/18.
//  Copyright © 2018 Roman Malasnyak. All rights reserved.
//
//

import Foundation
import CoreData


extension Annotation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Annotation> {
        return NSFetchRequest<Annotation>(entityName: "Annotation")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longtitude: Double
    @NSManaged public var user: User?

}
