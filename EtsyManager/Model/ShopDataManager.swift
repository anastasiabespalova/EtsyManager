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
    
    private lazy var historyRequestQueue = DispatchQueue(label: "history")
    
    private var lastHistoryToken: NSPersistentHistoryToken?
    
    private lazy var tokenFileURL: URL = {
      let url = NSPersistentContainer.defaultDirectoryURL()
        .appendingPathComponent("FireballWatch", isDirectory: true)
      do {
        try FileManager.default
          .createDirectory(
            at: url,
            withIntermediateDirectories: true,
            attributes: nil)
      } catch {
        // log any errors
      }
      return url.appendingPathComponent("token.data", isDirectory: false)
    }()
    
    private func storeHistoryToken(_ token: NSPersistentHistoryToken) {
      do {
        let data = try NSKeyedArchiver
          .archivedData(withRootObject: token, requiringSecureCoding: true)
        try data.write(to: tokenFileURL)
        lastHistoryToken = token
      } catch {
        // log any errors
      }
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "EtsyManager")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to initialize Core Data Stack \(error)")
            }
        }
        
        let persistentStoreDescription = persistentContainer.persistentStoreDescriptions.first
        
        persistentStoreDescription?.setOption(
          true as NSNumber,
          forKey: NSPersistentHistoryTrackingKey)
        
        loadHistoryToken()
        print(lastHistoryToken ?? "no history")
    }
    
    private func loadHistoryToken() {
      do {
        let tokenData = try Data(contentsOf: tokenFileURL)
        lastHistoryToken = try NSKeyedUnarchiver
          .unarchivedObject(ofClass: NSPersistentHistoryToken.self, from: tokenData)
      } catch {
        // log any errors
      }
    }
    
    private func mergeChanges(from transactions: [NSPersistentHistoryTransaction]) {
       let context = viewContext
       context.perform {
         transactions.forEach { transaction in
           guard let userInfo = transaction.objectIDNotification().userInfo else {
             return
           }

           NSManagedObjectContext
             .mergeChanges(fromRemoteContextSave: userInfo, into: [context])
         }
       }
     }
    
    func processRemoteStoreChange(_ notification: Notification) {
       historyRequestQueue.async {
         let backgroundContext = self.persistentContainer.newBackgroundContext()
         backgroundContext.performAndWait {
           let request = NSPersistentHistoryChangeRequest
             .fetchHistory(after: self.lastHistoryToken)

           if let historyFetchRequest = NSPersistentHistoryTransaction.fetchRequest {
            // historyFetchRequest.predicate =
            //   NSPredicate(format: "%K != %@", "author", PersistenceController.authorName)
             request.fetchRequest = historyFetchRequest
           }

           do {
             let result = try backgroundContext.execute(request) as? NSPersistentHistoryResult
             guard
               let transactions = result?.result as? [NSPersistentHistoryTransaction],
               !transactions.isEmpty
             else {
               return
             }
             // Update the viewContext with the changes
             self.mergeChanges(from: transactions)

             if let newToken = transactions.last?.token {
             // Update the history token using the last transaction.
               self.storeHistoryToken(newToken)
             }
           } catch {
            _ = error as NSError
           }
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
    
    func getListingsCountHistory(for shop_id: Int) -> ListingsCountHistory {
        let request: NSFetchRequest<ListingsCountHistory> = ListingsCountHistory.fetchRequest(NSPredicate(format: "shop_id = %@", NSNumber(value: shop_id)))
        if let listingCountHistory = try! viewContext.fetch(request).first {
            return listingCountHistory
        } else {
            return ListingsCountHistory()
        }
    }
    
    func getAllListingsCountHistoryForShop(for shop_id: Int) -> [ListingsCountHistory] {
        let request: NSFetchRequest<ListingsCountHistory> = ListingsCountHistory.fetchRequest(NSPredicate(format: "shop_id = %@", NSNumber(value: shop_id)))
        return try! viewContext.fetch(request)
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
    
    func getAllInactiveListingsForShop(id: Int) -> [Listing] {
        let associatedShop = Shop.withId(id, context: self.viewContext)
        let request: NSFetchRequest<Listing> = Listing.fetchRequest(NSPredicate(format: "fromShop_ = %@ AND ( state = %@ OR state = %@ )", argumentArray: [associatedShop, "inactive", "sold"]))
        //request.propertiesToGroupBy = [ "listing_id" ]
        request.sortDescriptors = [ NSSortDescriptor(key: "updated_at", ascending: false) ]
        do {
            return try viewContext.fetch(request)
               
          } catch {
              return []
          }
    }
    
    func getListingImages(id: Int) -> [ListingImageURLs] {
       // let associatedListing = Listing.withId(id, context: self.viewContext)
       // let request: NSFetchRequest<ListingImageURLs> = ListingImageURLs.fetchRequest(NSPredicate(format: "forListing_ = %@", argumentArray: [associatedListing]))
        let request: NSFetchRequest<ListingImageURLs> = ListingImageURLs.fetchRequest(NSPredicate(format: "listing_id = %@", argumentArray: [id]))
        //request.propertiesToGroupBy = [ "listing_id" ]
        request.sortDescriptors = [ NSSortDescriptor(key: "rank", ascending: true) ]
        do {
            return try viewContext.fetch(request)
               
          } catch {
              return []
          }
    }
    
    
    func loadActiveListingsForShop(id: Int) -> [Listing] {
        let associatedShop = Shop.withId(id, context: self.viewContext)
        let request: NSFetchRequest<Listing> = Listing.fetchRequest(NSPredicate(format: "fromShop_ = %@", argumentArray: [associatedShop]))
        //request.propertiesToGroupBy = [ "listing_id" ]
        request.sortDescriptors = [ NSSortDescriptor(key: "updated_at", ascending: false) ]
        do {
            return try viewContext.fetch(request)
               
          } catch {
              return []
          }
    }
    
    func getActiveListingsForShop(id: Int) -> [Listing] {
        
        // load from api
        loadAllActiveListings(id: id)
        
        let associatedShop = Shop.withId(id, context: self.viewContext)
        let request: NSFetchRequest<Listing> = Listing.fetchRequest(NSPredicate(format: "fromShop_ = %@ AND state = %@", argumentArray: [associatedShop, "active"]))
        
        do {
            let listings = try viewContext.fetch(request)
            return listings
        } catch {
            return []
        }
    }
    
    // TODO: refresh old versions of listings
    func refreshListingsByDate() {
        
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
//        DispatchQueue.global(qos: .default).async {
//            _ = Listing.loadAllActive(id, context: self.viewContext)
//            self.save()
//        }
        
        let associatedShop = Shop.withId(id, context: viewContext)
        let request: NSFetchRequest<Listing> = Listing.fetchRequest(NSPredicate(format: "fromShop_ = %@ AND state = %@", argumentArray: [associatedShop, "active"]))
        request.propertiesToFetch = ["listing_id"]
        let currentActiveListingsIDs = try? viewContext.fetch(request)
        currentActiveListingsIDs?.forEach{ listing in
            Listing.makeListingInactive(id: Int(listing.listing_id), context: viewContext)
             }
        
        let activeListingsNumber = Shop.withId(id, context: viewContext).listing_active_count
        var offset = 0
        while offset < activeListingsNumber {
            _ = Listing.loadAllActive(id, offset: offset, context: viewContext)
            //_ = Listing.getAllActiveListingsPhotos(id, offset: offset, context: viewContext)
            save()
            offset += 100
        }
        
    }
    
    
    // MARK: - Deleting
    
    func resetAllListings() // entity = Your_Entity_Name
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
    
    func resetAllShops() // entity = Your_Entity_Name
        {

            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Shop")
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
    
    // MARK: -Images
    
}
