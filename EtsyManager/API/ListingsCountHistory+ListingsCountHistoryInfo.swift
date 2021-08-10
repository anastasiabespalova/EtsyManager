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
           //request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
            request.predicate = predicate
            return request
        }
    
    static func withId(_ id: Int, context: NSManagedObjectContext) -> ListingsCountHistory {
        
        let request = fetchRequest(NSPredicate(format: "shop_id = %@", NSNumber(value: id)))
        let shopHistoryResults = (try? context.fetch(request)) ?? []
        if let shopHistory = shopHistoryResults.first {
                // if found, return it
            return shopHistory
        } else {
            let shopHistory = ShopHistory(context: context)
            shopHistory.shop_id = Int64(id)
            do {
                let shopHistoryInfo = ShopHistoryInfo(id: id, isChecked: false)
                self.update(from: shopHistoryInfo, context: context)
                return shopHistory
            }
        }
    }

    static func update(from info: ListingsCountHistoryInfo, context: NSManagedObjectContext) {
        let listingsCountHistory = self.withId(info.id, context: context)
        listingsCountHistory.shop_id = Int64(info.shop_id)
            
            shopHistory.listingsCountHistory.forEach { $0.objectWillChange.send() }
            
            shopHistory.forShop = Shop.withId(info.shop_id!, context: context)
                try? context.save()
            }
    }
    

    
}


struct ListingsCountHistoryInfo: Codable, Hashable, Identifiable, Comparable {
    var id: Int { Int(timestamp) }
    
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

    
    init(shop: Shop) {
        self.timestamp = Date()
        self.shop_id = shop.shop_id
        self.soldListingsCount = shop.listing_sold_count
        self.activeListingsCount = shop.listing_active_count
        self.inactiveListingsCount = shop.listing_inactive_count
    }
    
    
    
}
