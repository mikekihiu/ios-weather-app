//
//  TestCoreDataStack.swift
//  Favourite MapTests
//
//  Created by Mike on 16/11/2020.
//

import XCTest
import CoreData
@testable import Favourite_Map

class TestCoreDataStack : CoreDataStack {
    
    override init() {
        super.init()
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType

        let container = NSPersistentContainer(name: CoreDataStack.Model.Favourite_Map.rawValue)
        container.persistentStoreDescriptions = [persistentStoreDescription]

        container.loadPersistentStores { _, error in
          if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
          }
        }
        persistentContainer = container
    }
    
}
