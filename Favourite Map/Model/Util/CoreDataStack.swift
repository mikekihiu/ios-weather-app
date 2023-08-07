//
//  CoreDataStack.swift
//  Favourite Map
//
//  Created by Mike on 12/11/2020.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
        
    var persistentContainer:NSPersistentContainer
    
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    let backgroundContext:NSManagedObjectContext!
    
    init() {
        persistentContainer = NSPersistentContainer(name: Model.Favourite_Map.rawValue)
        backgroundContext = persistentContainer.newBackgroundContext()
    }
    
    func configureContexts() {
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.autoSaveViewContext()
            self.configureContexts()
            completion?()
        }
    }
}

extension CoreDataStack {
    
    enum Model: String {
        case Favourite_Map
    }
    
    enum Cache: String  {
        case bookmarks
    }
    
    func saveViewContext() {
        try? viewContext.save()
    }
    
    func autoSaveViewContext(interval:TimeInterval = 30) {
        guard interval > 0 else {
            #if DEBUG
            print("cannot set negative autosave interval")
            #endif
            return
        }
        if viewContext.hasChanges {
            saveViewContext()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
    }
}
