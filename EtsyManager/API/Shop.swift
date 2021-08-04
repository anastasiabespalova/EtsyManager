//
//  Shop.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 03.08.2021.
//
import CoreData
import Foundation

extension Shop {
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
                        self.update(from: shopInfo, context: context)
                    } catch let error {
                       print(error)
                    }
                  }
               // self.update(from: shopInfo, context: context)
                print("success2! shopName: \(shopInfo.shop_name)")
                return shop
            }
        }
    
    static func loadShopWithId(_ id: Int, context: NSManagedObjectContext) -> Shop {
        let shop = Shop(context: context)
        shop.shop_id = Int64(id)
        let etsy = EtsyAPI()
        var shopInfo = ShopInfo()
        //let sem = DispatchSemaphore(value: 0)
        etsy.getShopInfo(for: id) { (inner: () throws -> ShopInfo?) -> Void in
            do {
                shopInfo = try inner()!
               // sem.signal()
            } catch let error {
               print(error)
            }
          }
       // sem.wait()
        print("success2! shopName: \(shopInfo.shop_name)")
        
       // self.update(from: shopInfo, context: context)
        return shop
    }
    
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Shop> {
            let request = NSFetchRequest<Shop>(entityName: "Shop")
            request.sortDescriptors = [NSSortDescriptor(key: "last_modified_tsz", ascending: true)]
            request.predicate = predicate
            return request
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
        print("shop_name: \(shop.shop_name ?? "no name")")
                /*
                airport.flightsTo.forEach { $0.objectWillChange.send() }
                airport.flightsFrom.forEach { $0.objectWillChange.send() } */
                try? context.save()
            }
        }
}
