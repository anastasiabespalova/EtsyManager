//
//  Shop.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 03.08.2021.
//
import CoreData
import Foundation

extension Shop {
    
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Shop> {
            let request = NSFetchRequest<Shop>(entityName: "Shop")
            request.sortDescriptors = [NSSortDescriptor(key: "last_modified_tsz", ascending: true)]
            request.predicate = predicate
            return request
        }
    
    
    // html request
    static func updateSoldListingCount(_ id: Int, context: NSManagedObjectContext) -> Shop? {
        let request = fetchRequest(NSPredicate(format: "shop_id = %@", NSNumber(value: id)))
            let shops = (try? context.fetch(request)) ?? []
            if let shop = shops.first {
                do {
                    let listing_sold_count = getNumberOfSales(for: shop.shop_name!)
                    shop.setValue(Int16(listing_sold_count), forKey: "listing_sold_count")
                    shop.setValue(true, forKey: "is_listing_sold_count_updated")
                    try context.save()
                } catch let error {
                    print(error)
                }
                return shop
            } else {
                return nil
            }
    }
    
    // request to api
    static func updateShopWithId(_ id: Int, context: NSManagedObjectContext) -> Shop? {
        let request = fetchRequest(NSPredicate(format: "shop_id = %@", NSNumber(value: id)))
            let shops = (try? context.fetch(request)) ?? []
            if let shop = shops.first {
                let etsy = EtsyAPI()
                var shopInfo = ShopInfo()
                etsy.getShopInfo(for: id) { (inner: () throws -> ShopInfo?) -> Void in
                    do {
                        shopInfo = try inner()!
                       self.updateExistingShop(from: shopInfo, for: shop, context: context)
                        
                    } catch let error {
                       print(error)
                    }
                  }
                print("successful update! shopName: \(shopInfo.shop_name)")
                return shop
            } else {
                return nil
            }
    }
    

    
    static func withId(_ id: Int, context: NSManagedObjectContext) -> Shop {
            // look up icao in Core Data
        let request = fetchRequest(NSPredicate(format: "shop_id = %@", NSNumber(value: id)))
            let shops = (try? context.fetch(request)) ?? []
            if let shop = shops.first {
                // if found, return it
                return shop
            } else {
                // if not, create one and fetch from FlightAware
                let shop = Shop(context: context)
                shop.shop_id = Int64(id)
                let etsy = EtsyAPI()
                var shopInfo = ShopInfo()
                etsy.getShopInfo(for: id) { (inner: () throws -> ShopInfo?) -> Void in
                    do {
                        shopInfo = try inner()!
                      //  shopInfo.listing_sold_count = getNumberOfSales(for: shopInfo.shop_name)
                        self.update(from: shopInfo, context: context)
                        _ = self.updateSoldListingCount(id, context: context)
                    } catch let error {
                       print(error)
                    }
                  }
                print("success2! shopName: \(shopInfo.shop_name)")
                return shop
            }
        }
    

    
    
    static func update(from info: ShopInfo, context: NSManagedObjectContext) {
        if let id = info.shop_id {
       //let id = info.shop_id!
                let shop = self.withId(id, context: context)
                shop.creation_tsz = info.creation_tsz
                shop.digital_listing_count = Int16(info.digital_listing_count)
                shop.digital_sale_message = info.digital_sale_message
                shop.icon_url_fullxfull = info.icon_url_fullxfull
                shop.last_modified_tsz = info.last_modified_tsz
                shop.listing_active_count = Int16(info.listing_active_count)
                shop.listing_inactive_count = Int16(info.listing_inactive_count)
                shop.listing_sold_count = Int16(info.listing_sold_count)
                shop.sale_message = info.sale_message
                shop.shop_name = info.shop_name
                shop.is_listing_sold_count_updated = false
        print("shop_name: \(shop.shop_name ?? "no name")")
                /*
                airport.flightsTo.forEach { $0.objectWillChange.send() }
                airport.flightsFrom.forEach { $0.objectWillChange.send() } */
                try? context.save()
            }
        }
    
    var withListings: Set<Listing> {
            get { (withListings_ as? Set<Listing>) ?? [] }
            set { withListings_ = newValue as NSSet }
        }
    
    static func updateExistingShop(from info: ShopInfo, for shop: Shop, context: NSManagedObjectContext) {
            shop.setValue(info.creation_tsz, forKey: "creation_tsz")
            shop.setValue(Int16(info.digital_listing_count), forKey: "digital_listing_count")
            shop.setValue(info.digital_sale_message, forKey: "digital_sale_message")
            shop.setValue(info.icon_url_fullxfull, forKey: "icon_url_fullxfull")
            shop.setValue(info.last_modified_tsz, forKey: "last_modified_tsz")
            shop.setValue(Int16(info.listing_active_count), forKey: "listing_active_count")
            shop.setValue(Int16(info.listing_inactive_count), forKey: "listing_inactive_count")
            shop.setValue(Int16(info.listing_sold_count), forKey: "listing_sold_count")
            shop.setValue(info.sale_message, forKey: "sale_message")
            shop.setValue(info.shop_name, forKey: "shop_name")
            shop.setValue(false, forKey: "is_listing_sold_count_updated")
        
        shop.withListings.forEach { $0.objectWillChange.send() }
                   // airport.flightsFrom.forEach { $0.objectWillChange.send() }
                /*
                airport.flightsTo.forEach { $0.objectWillChange.send() }
                airport.flightsFrom.forEach { $0.objectWillChange.send() } */
                try? context.save()
            }
}
