//
//  ShopDataManager.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 03.08.2021.
//


import Foundation
import CoreData

class ShopDataManager {
    
    // MARK: - Initializing and saving
    
    let persistentContainer: NSPersistentContainer
    static let shared = ShopDataManager()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "EtsyManager")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to initialize Core Data Stack \(error)")
            }
        }
    }
    
    func save() {
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Getting from memory
    
    func getAllShops() -> [Shop] {
        let request: NSFetchRequest<Shop> = Shop.fetchRequest()
        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
    }
    
    func getAllActiveListings(id: Int) -> [Listing] {
        loadAllActiveListings(id: id)
        let request: NSFetchRequest<Listing> = Listing.fetchRequest()
        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
    }
    
    func loadActiveListingsForShop(id: Int) -> [Listing] {
        let associatedShop = Shop.withId(id, context: self.viewContext)
                let request: NSFetchRequest<Listing> = Listing.fetchRequest(NSPredicate(format: "fromShop_ = %@", argumentArray: [associatedShop]))
        do {
            
              return try viewContext.fetch(request)
          } catch {
              return []
          }
    }
    
    func getActiveListingsForShop(id: Int) -> [Listing] {
        DispatchQueue.global(qos: .userInitiated).async {
            self.loadAllActiveListings(id: id)
            
          
        }
        let associatedShop = Shop.withId(id, context: self.viewContext)
                let request: NSFetchRequest<Listing> = Listing.fetchRequest(NSPredicate(format: "fromShop_ = %@", argumentArray: [associatedShop]))
        do {
            
              return try viewContext.fetch(request)
          } catch {
              return []
          }
      /*  loadAllActiveListings(id: id)
        let associatedShop = Shop.withId(id, context: viewContext)
        let request: NSFetchRequest<Listing> = Listing.fetchRequest(NSPredicate(format: "fromShop_ = %@", argumentArray: [associatedShop]))
        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
        */
       /* let myFetch:NSFetchRequest<Listing> = Listing.fetchRequest()
        let associatedShop = Shop.withId(id, context: viewContext)
        let myPredicate = NSPredicate(format: "fromShop == %@", (associatedShop))
        myFetch.predicate = myPredicate
        do {
                return try viewContext.fetch(myFetch)
            } catch{
               return []
            } */
       /* let myPredicate = NSPredicate(format: "fromShop_.shop_id = %@", id)
        let myFetch: NSFetchRequest<Listing> = Listing.fetchRequest()
        myFetch.predicate = myPredicate
        do {
                return try viewContext.fetch(myFetch)
            } catch{
               return []
            } */
    }
    
    
    // MARK: - Updating existing
    
    // update Shop Info without sold listing count
    func updateAllShops() -> [Shop] {
        let request: NSFetchRequest<Shop> = Shop.fetchRequest()
        do {
            let currentShops = try viewContext.fetch(request)
            currentShops.forEach() { shop in
                _ = Shop.updateShopWithId(Int(shop.shop_id), context: viewContext)
            }
            save()
            return try viewContext.fetch(request)
        } catch {
            return []
        }
    }
    
    // update Shop Info of sold listings count
    func updateAllShopsSoldListingsCount() -> [Shop] {
        let request: NSFetchRequest<Shop> = Shop.fetchRequest()
        do {
            let currentShops = try viewContext.fetch(request)
            currentShops.forEach() { shop in
                    _ = Shop.updateSoldListingCount(Int(shop.shop_id), context: viewContext)
            }
            save()
            return try viewContext.fetch(request)
        } catch {
            return []
        }
    }
    
    func updateShopSoldListingCount(id: Int) -> Shop {
        do {
            _ = Shop.updateSoldListingCount(id, context: viewContext)
            save()
            let newRequest = Shop.fetchRequest(NSPredicate(format: "shop_id = %@", NSNumber(value: id)))
            return try viewContext.fetch(newRequest).first!
        } catch {
            let newRequest = Shop.fetchRequest(NSPredicate(format: "shop_id = %@", NSNumber(value: id)))
            return try! viewContext.fetch(newRequest).first!
        }
    }
    

    // MARK: - Loading
    
    // for shop with shop_id = id
    func loadShopWithId(_ id: Int) {
        _ = Shop.withId(id, context: viewContext)
        save()
    }
    
    // for listing with listing_id = id
    func loadListingInfo(id: Int) {
            _ = Listing.withId(id, context: viewContext)
            save()
    }
    
    // for shop with shop_id = id
    func loadAllActiveListings(id: Int) {
        _ = Listing.loadAllActive(id, context: viewContext)
        save()
    }
    
    
    // MARK: - Deleting
    
    func resetAllRecords() // entity = Your_Entity_Name
        {

            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Listing")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            do
            {
                try viewContext.execute(deleteRequest)
                try viewContext.save()
            }
            catch
            {
                print ("There was an error")
            }
        }
    
}
