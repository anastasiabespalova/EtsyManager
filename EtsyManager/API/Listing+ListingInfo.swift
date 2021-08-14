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
                    //TODO: think how to deal with offset when sold listings tracking
                   /* currentActiveListingsIDs?.forEach{ listing in
                        if !listingInfoArray.contains(where: { $0.listing_id == listing.listing_id }) {
                            self.makeListingInactive(id: Int(listing.listing_id), context: context)
                        }
                    } */
                    listingInfoArray.indices.forEach { idx in
                        listingInfoArray[idx].shop_id = id
                    }
                    
                    listingInfoArray.forEach { listingInfo in
                        let request = fetchRequest(NSPredicate(format: "listing_id = %@", NSNumber(value: listingInfo.listing_id)))
                        let listings = (try? privateMOC.fetch(request)) ?? []
                         if listings.first != nil {
                            self.update(from: listingInfo, context: context, privateContext: privateMOC)
                        } else {
                            let listing = Listing(context: privateMOC)
                            listing.listing_id = Int64(listingInfo.listing_id)
                            self.update(from: listingInfo, context: context, privateContext: privateMOC)
                           // print("before withID")
                            for image in listingInfo.images {
                               // print("withID")
                                _ = ListingImageURLs.withId(image.listing_image_id, listingImageURLsInfo: image, context: context)
                            }
                           
                        }
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
    
    var withPhotos: Set<ListingImageURLs> {
            get { (withPhotos_ as? Set<ListingImageURLs>) ?? [] }
            set { withPhotos_ = newValue as NSSet }
        }
    
    static func makeListingInactive(id: Int, context: NSManagedObjectContext) {
        let listing = self.withId(id, context: context)
        listing.state = "sold"
        try? context.save()
       // print("Made Listing sold: \(id)")
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
        
      //  listing.withPhotos = info.images
        
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


struct ListingInfo: Codable, Identifiable, Comparable {
    static func == (lhs: ListingInfo, rhs: ListingInfo) -> Bool {
        lhs.listing_id == rhs.listing_id
    }
    
    var id: Int { listing_id }
    
    var creation_tsz: Float
    var is_digital: Bool
    var is_private: Bool
    var item_dimensions_unit: String
    var item_height: Int
    var item_width: Int
    var last_modified_tsz: Float
    var listing_description: String
    var listing_id: Int
    var num_favorers: Int
    var price: String
    var quantity: Int
    var state: String
    var tags: String
    var title: String
    var views: Int
    var shop_id: Int
   
    var images: [ListingImageURLsInfo]
    
    static func < (lhs: ListingInfo, rhs: ListingInfo) -> Bool {
        lhs.last_modified_tsz < rhs.last_modified_tsz
    }
    
    init() {
        creation_tsz = 0
        is_digital = false
        is_private = false
        item_dimensions_unit = ""
        item_height = 0
        item_width = 0
        last_modified_tsz = 0
        listing_description = ""
        listing_id = 0
        num_favorers = 0
        price = ""
        quantity = 0
        state = ""
        tags = ""
        title = ""
        views = 0
        shop_id = 0
        images = []
    }
    
    init(listing: Listing) {
       // print("init")
        
        self.listing_id = Int(listing.listing_id)
        self.creation_tsz = listing.creation_tsz
        self.is_digital = listing.is_digital
        self.is_private = listing.is_private
        self.item_dimensions_unit = listing.item_dimensions_unit ?? ""
        self.item_height = Int(listing.item_height)
        self.item_width = Int(listing.item_width)
        self.last_modified_tsz = listing.last_modified_tsz
        self.listing_description = listing.listing_description ?? ""
        self.num_favorers = Int(listing.num_favorers)
        self.price = listing.price ?? ""
        self.quantity = Int(listing.quantity)
        self.state = listing.state ?? ""
        self.tags = listing.tags ?? ""
        self.title = listing.title ?? ""
        self.views = Int(listing.views)
        self.shop_id = Int(listing.fromShop.shop_id)
        
        self.images = []
        let images = ShopDataManager.shared.getListingImages(id: listing_id)
        for image in images {
            self.images.append(ListingImageURLsInfo(listingImageURLs: image))
            //print("appended image with id \(image.listing_image_id)")
        }
        
        
      /*  for image in listing.withPhotos {
            self.images.append(ListingImageURLsInfo(listingImageURLs: image))
            print("appended image with id \(image.listing_image_id)")
        }*/
    }
    
    
    
}
