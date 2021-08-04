//
//  ShopDataManager.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 03.08.2021.
//


import Foundation
import CoreData

class ShopDataManager {
    
    let persistentContainer: NSPersistentContainer
    static let shared = ShopDataManager()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func deleteShop(shop: Shop) {
        viewContext.delete(shop)
        save()
    }
    
    func getShopById(id: NSManagedObjectID) -> Shop? {
        
        do {
            return try viewContext.existingObject(with: id) as? Shop
        } catch {
            return nil
        }
    }
    
    func getAllShops() -> [Shop] {
        
        let request: NSFetchRequest<Shop> = Shop.fetchRequest()
        
        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
        
    }
    
    func loadAllShops() {
        Shop.withId(27991754, context: viewContext)
       // Shop.withId(27991740, context: viewContext)
    }
    
    func loadShopWithId(_ id: Int) {
        //Shop.loadShopWithId(id, context: viewContext)
        Shop.withId(id, context: viewContext)
    }
    
    func save() {
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            print(error.localizedDescription)
        }
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "EtsyManager")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to initialize Core Data Stack \(error)")
            }
        }
    }
    
}
