//
//  CoreDataManager.swift
//  MoviesDB
//
//  Created by Ivan Bolgov on 10.12.2023.
//

import CoreData

protocol CoreDataManagerProtocol {
    func create<T: NSManagedObject>(type: T.Type, mode: CoreDataFetchMode, initialization: @escaping ((T?) -> Void), completion: ((T?) -> Void)?)

    func fetch<T: NSManagedObject>(type: T.Type, predicate: NSPredicate?, mode: CoreDataFetchMode, completion: @escaping (([T]?) -> Void))
    
    func clear<T: NSManagedObject>(type: T.Type, mode: CoreDataFetchMode, completion: ((Bool) -> Void)?)
}

final class CoreDataManager: CoreDataManagerProtocol {
    
    private var container: NSPersistentContainer!
    
    private lazy var writeMoc: NSManagedObjectContext = {
        let newbackgroundContext = container.newBackgroundContext()
        newbackgroundContext.automaticallyMergesChangesFromParent = true
        newbackgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return newbackgroundContext
    }()
    
    private lazy var mainMoc: NSManagedObjectContext = {
        return container.viewContext
    }()
    
    init(modelName: String) {
        container = NSPersistentContainer(name: modelName)

        container.loadPersistentStores { storeDescription, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
    }
    
    func create<T: NSManagedObject>(type: T.Type, mode: CoreDataFetchMode, initialization: @escaping ((T?) -> Void), completion: ((T?) -> Void)?) {
        
        let managedObjectContext = context(by: mode)
        
        managedObjectContext.perform { [weak self] in
            let object = NSManagedObject.init(entity: type.entity(), insertInto: managedObjectContext)
            initialization(object as? T)
            self?.save(managedObjectContext)
            completion?(object as? T)
        }
    }
    
    func fetch<T: NSManagedObject>(type: T.Type, predicate: NSPredicate?, mode: CoreDataFetchMode, completion: @escaping (([T]?) -> Void)) {
        
        let managedObjectContext = context(by: mode)
        
        managedObjectContext.perform {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: type))
            
            if let predicate = predicate {
                request.predicate = predicate
            }

            do {
                let result = try managedObjectContext.fetch(request)
                completion(result as? [T])
            } catch {
                completion(nil)
            }
        }
    }
    
    func clear<T: NSManagedObject>(type: T.Type, mode: CoreDataFetchMode, completion: ((Bool) -> Void)?) {
        
        let managedObjectContext = context(by: mode)
        
        managedObjectContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: type))
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try managedObjectContext.execute(batchDeleteRequest)
                completion?(true)
            } catch {
                completion?(false)
            }
        }
    }
    
    private func save(_ moc: NSManagedObjectContext) {
        guard moc.hasChanges else { return }
        do {
            try moc.save()
        } catch {
            print("An error occurred while saving: \(error)")
        }
    }
    
    private func context(by fetchMode: CoreDataFetchMode) -> NSManagedObjectContext {
        switch fetchMode {
        case .UI:
            return mainMoc
        case .background:
            return writeMoc
        }
    }
}
