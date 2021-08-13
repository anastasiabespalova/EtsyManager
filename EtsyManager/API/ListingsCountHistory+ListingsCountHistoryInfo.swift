//
//  ShopHistory.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 10.08.2021.
//

import CoreData
import Foundation

extension ListingsCountHistory {
    
    var forShop: Shop {
            get { forShop_!} // TODO: protect against nil before shipping?
            set { forShop_ = newValue }
        }
    
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<ListingsCountHistory> {
            let request = NSFetchRequest<ListingsCountHistory>(entityName: "ListingsCountHistory")
            request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
            request.predicate = predicate
            return request
    }
    
    static func update(shop_id: Int, context: NSManagedObjectContext)  {
        
        let shop = Shop.withId(Int(shop_id), context: context)
        if hasSomethingChanged(shop: shop, context: context) {
            print("Updated history for shop: \(shop.shop_name ?? "")")
            
            let listingsCountHistoryInfo = ListingsCountHistoryInfo(shop: shop)
            let listingsCountHistory = ListingsCountHistory(context:context)
            listingsCountHistory.activeListingsCount = listingsCountHistoryInfo.activeListingsCount
            listingsCountHistory.inactiveListingsCount = listingsCountHistoryInfo.inactiveListingsCount
            listingsCountHistory.soldListingsCount = listingsCountHistoryInfo.soldListingsCount
            listingsCountHistory.timestamp = listingsCountHistoryInfo.timestamp
            listingsCountHistory.forShop = shop
            listingsCountHistory.shop_id = shop.shop_id

            listingsCountHistory.objectWillChange.send()
            try? context.save()
        } else {
            print("Didn't update history for shop: \(shop.shop_name ?? "") ")
        }
       
        
    }
    
    static func hasSomethingChanged(shop: Shop, context: NSManagedObjectContext) -> Bool {
        let request = fetchRequest(NSPredicate(format: "shop_id = %@", NSNumber(value: shop.shop_id)))
        let listingsCountHistories = (try? context.fetch(request)) ?? []
        if let lastListingCountHistory = listingsCountHistories.first {
            if lastListingCountHistory.inactiveListingsCount == shop.listing_inactive_count,
               lastListingCountHistory.activeListingsCount == shop.listing_active_count,
               lastListingCountHistory.soldListingsCount == shop.listing_sold_count {
                return false
            } else {
                return true
            }
        } else {
            return true
        }
    }
    
}


struct ListingsCountHistoryInfo: Codable, Hashable, Comparable {
   // var id: Int { shop_id }
    
    static func < (lhs: ListingsCountHistoryInfo, rhs: ListingsCountHistoryInfo) -> Bool {
        lhs.shop_id < rhs.shop_id
    }
    
    var timestamp: Date
    var shop_id: Int64
    var soldListingsCount: Int16
    var inactiveListingsCount: Int16
    var activeListingsCount: Int16
    
    init() {
        shop_id = 0
        soldListingsCount = 0
        inactiveListingsCount = 0
        activeListingsCount = 0
        timestamp = Date()
    }
    
    init(history: ListingsCountHistory) {
        self.timestamp = history.timestamp!
        self.shop_id = history.shop_id
        self.soldListingsCount = history.soldListingsCount
        self.activeListingsCount = history.activeListingsCount
        self.inactiveListingsCount = history.inactiveListingsCount
    }

    
    init(shop: Shop) {
        self.timestamp = Date()
        self.shop_id = shop.shop_id
        self.soldListingsCount = shop.listing_sold_count
        self.activeListingsCount = shop.listing_active_count
        self.inactiveListingsCount = shop.listing_inactive_count
    }
    
    init(shopInfo: ShopInfo) {
        self.timestamp = Date()
        self.shop_id = Int64(shopInfo.shop_id!)
        self.soldListingsCount = Int16(shopInfo.listing_sold_count)
        self.activeListingsCount = Int16(shopInfo.listing_active_count)
        self.inactiveListingsCount = Int16(shopInfo.listing_inactive_count)
    }
    
    
    
}
