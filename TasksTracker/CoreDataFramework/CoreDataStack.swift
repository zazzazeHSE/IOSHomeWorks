//
//  CoreDataStack.swift
//  CoreDataFramework
//
//  Created by Егор on 26.02.2021.
//

import Foundation
import CoreData

public class CoreDataStack {
    public static let shared = CoreDataStack()
    
    private init() {}
    
    public var managedObjectContext: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let containerUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.zazzaze.tasks")!
        let storeUrl = containerUrl.appendingPathComponent("Tasks.sqlite")
        let description = NSPersistentStoreDescription(url: storeUrl)
        let container = NSPersistentContainer(name: "Tasks")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { storeDescription, error in
            container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            if let error = error {
                print(error.localizedDescription)
            }
        }
        return container
    }()
}
