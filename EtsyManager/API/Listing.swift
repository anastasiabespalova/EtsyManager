//
//  Listing.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 02.08.2021.
//

import Foundation
import CoreData

extension Listing: Comparable {
    
    public static func < (lhs: Listing, rhs: Listing) -> Bool {
        lhs.last_modified_tsz < rhs.last_modified_tsz
    }
    
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Listing> {
            let request = NSFetchRequest<Listing>(entityName: "Listing")
            request.sortDescriptors = [NSSortDescriptor(key: "last_modified_tsz", ascending: true)]
            request.predicate = predicate
            return request
        }
    
    static func loadAllActive(_ id: Int, offset: Int, context: NSManagedObjectContext) -> [ListingInfo] {
        var listingInfoArray: [ListingInfo] = []
        
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = context
        
        privateMOC.perform {
        
        let etsy = EtsyAPI()
            
            etsy.getAllActiveListings(for: id, offset: offset) { (inner: () throws -> [ListingInfo]?) -> Void in
                do {
                    listingInfoArray = try inner()!
                    listingInfoArray.indices.forEach { idx in
                        listingInfoArray[idx].shop_id = id
                    }
                    listingInfoArray.forEach { listingInfo in
                       // let request = fetchRequest(NSPredicate(format: "listing_id = %@", NSNumber(value: listingInfo.listing_id)))
                       // let listings = (try? privateMOC.fetch(request)) ?? []
                        // if listings.first != nil {
                          //  self.update(from: listingInfo, context: context, privateContext: privateMOC)
                      //  } else {
                            let listing = Listing(context: privateMOC)
                            listing.listing_id = Int64(listingInfo.listing_id)
                            self.update(from: listingInfo, context: context, privateContext: privateMOC)
                      //  }
                    }
                } catch let error {
                   print(error)
                }
              }
        }
        return listingInfoArray
    }
        
    
    static func withId(_ id: Int, context: NSManagedObjectContext) -> Listing {
            // look up icao in Core Data
        let request = fetchRequest(NSPredicate(format: "listing_id = %@", NSNumber(value: id)))
            let listings = (try? context.fetch(request)) ?? []
            if let listing = listings.first {
                // if found, return it
                return listing
            } else {
                let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                privateMOC.parent = context
                //let listing = Listing(context: context)
                let listing = Listing(context: privateMOC)
                privateMOC.perform {
                
                // if not, create one and fetch from FlightAware
                
                listing.listing_id = Int64(id)
                let etsy = EtsyAPI()
                var listingInfo = ListingInfo()
                etsy.getListingInfo(for: id) { (inner: () throws -> ListingInfo?) -> Void in
                    do {
                        listingInfo = try inner() ?? ListingInfo()
                        //self.update(from: listingInfo, context: context)
                        self.update(from: listingInfo, context: context, privateContext: privateMOC)
                    } catch let error {
                       print(error)
                    }
                  }
                }
                //print("success2! shopName: \(listingInfo.listing_title)")
                return listing 
            }
        }
    
    var fromShop: Shop {
            get { fromShop_!} // TODO: protect against nil before shipping?
            set { fromShop_ = newValue }
        }
    
    static func update(from info: ListingInfo, context: NSManagedObjectContext, privateContext: NSManagedObjectContext) {
       // if let id = info.listing_id {
       //let id = info.shop_id!
        let id = info.listing_id
       // let listing = self.withId(id, context: context)
        let listing = self.withId(id, context: privateContext)
        listing.listing_id = Int64(info.listing_id)
            listing.creation_tsz = info.creation_tsz
            listing.is_digital = info.is_digital
            listing.is_private = info.is_private
            listing.item_dimensions_unit = info.item_dimensions_unit
        listing.item_height = Int16(info.item_height)
        listing.item_width = Int16(info.item_width)
            listing.last_modified_tsz = info.last_modified_tsz
            listing.listing_description = info.listing_description
        listing.num_favorers = Int16(info.num_favorers)
            listing.price = info.price
        listing.quantity = Int16(info.quantity)
            listing.state = info.state
            listing.tags = info.tags
            listing.title = info.title
        listing.views = Int16(info.views)
        //listing.fromShop = Shop.withId(info.shop_id, context: context)
        listing.fromShop = Shop.withId(info.shop_id, context: privateContext)
        
        let date = Date()
        listing.setValue(date.format(), forKey: "updated_at")
        
        listing.objectWillChange.send()
        print("listing: \(listing.title ?? "no name")")
        
        do {
                try privateContext.save()
            context.performAndWait {
                    do {
                        try context.save()
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                }
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            }
    
    static func update(from info: ListingInfo, context: NSManagedObjectContext) {
       // if let id = info.listing_id {
       //let id = info.shop_id!
        let id = info.listing_id
        let listing = self.withId(id, context: context)
        listing.listing_id = Int64(info.listing_id)
            listing.creation_tsz = info.creation_tsz
            listing.is_digital = info.is_digital
            listing.is_private = info.is_private
            listing.item_dimensions_unit = info.item_dimensions_unit
        listing.item_height = Int16(info.item_height)
        listing.item_width = Int16(info.item_width)
            listing.last_modified_tsz = info.last_modified_tsz
            listing.listing_description = info.listing_description
        listing.num_favorers = Int16(info.num_favorers)
            listing.price = info.price
        listing.quantity = Int16(info.quantity)
            listing.state = info.state
            listing.tags = info.tags
            listing.title = info.title
        listing.views = Int16(info.views)
        listing.fromShop = Shop.withId(info.shop_id, context: context)
        
        let date = Date()
        listing.setValue(date.format(), forKey: "updated_at")
        
        listing.objectWillChange.send()
        print("listing: \(listing.title ?? "no name")")
        try? context.save()
    }

}
