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
                    if let name = shop.shop_name {
                        let listing_sold_count = getNumberOfSales(for: name)
                        shop.setValue(Int16(listing_sold_count), forKey: "listing_sold_count")
                        shop.setValue(true, forKey: "is_listing_sold_count_updated")
                        try context.save()
                        ListingsCountHistory.update(shop_id: id, context: context)
                    } else {
                        return nil
                    }
                   
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
                        self.update(from: shopInfo, context: context)
                        _ = self.updateSoldListingCount(id, context: context)
                        ListingsCountHistory.update(shop_id: id, context: context)
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
            try? context.save()
            }
        }
    
    var withListings: Set<Listing> {
            get { (withListings_ as? Set<Listing>) ?? [] }
            set { withListings_ = newValue as NSSet }
        }
    
    var withListingsHistory: Set<ListingsCountHistory> {
            get { (withListingsHistory_ as? Set<ListingsCountHistory>) ?? [] }
            set { withListingsHistory_ = newValue as NSSet }
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
        //shop.withListingsHistory.forEach { $0.objectWillChange.send() }
        
        print("Shop icon URL: \(info.icon_url_fullxfull)")
        
        try? context.save()
        }
}

struct ShopInfo: Codable, Hashable, Identifiable, Comparable {
    var id: Int { shop_id ?? 0}
    
    var shop_id: Int?
    var creation_tsz: Float
    var digital_listing_count: Int
    var digital_sale_message: String
    var icon_url_fullxfull: String
    var last_modified_tsz: Float
    var listing_active_count: Int
    var listing_inactive_count: Int
    var listing_sold_count: Int
    var sale_message: String
    var shop_name: String
    var is_listing_sold_count_updated: Bool
    
    static func < (lhs: ShopInfo, rhs: ShopInfo) -> Bool {
        lhs.last_modified_tsz < rhs.last_modified_tsz
    }
    
    init() {
        shop_id = nil
        creation_tsz = 0
        digital_listing_count = 0
        digital_sale_message = ""
        icon_url_fullxfull = ""
        last_modified_tsz = 0
        listing_active_count = 0
        listing_inactive_count = 0
        listing_sold_count = 0
        sale_message = ""
        shop_name = ""
        is_listing_sold_count_updated = false
    }
    
    init(shop: Shop) {
        self.shop_id = Int(shop.shop_id)
        self.creation_tsz = shop.creation_tsz
        self.digital_listing_count = Int(shop.digital_listing_count)
        self.digital_sale_message = shop.digital_sale_message ?? ""
        self.icon_url_fullxfull = shop.icon_url_fullxfull ?? ""
        self.last_modified_tsz = shop.last_modified_tsz
        self.listing_active_count = Int(shop.listing_active_count)
        self.listing_inactive_count = Int(shop.listing_inactive_count)
        self.listing_sold_count = Int(shop.listing_sold_count)
        self.sale_message = shop.sale_message ?? ""
        self.shop_name = shop.shop_name ?? ""
        self.is_listing_sold_count_updated = shop.is_listing_sold_count_updated
    }
}
