//
//  ShopPreviewViewModel.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 03.08.2021.
//

import SwiftUI
import CoreData

class ShopPreviewViewModel: ObservableObject {
    
    var title: String = ""
    
    @Published var shopsInfo: [ShopInfo] = []
    @Published var listingsCountHistory: [ListingsCountHistoryInfo] = []
    
    var updateActiveListingsFor: [Int] = []
    
    func getAllShops() {
        shopsInfo.removeAll()
        listingsCountHistory.removeAll()
        
        ShopDataManager.shared.getAllShops().forEach { shop in
            shopsInfo.append(ShopInfo(shop: shop))
            listingsCountHistory.append(ListingsCountHistoryInfo(history: ShopDataManager.shared.getListingsCountHistory(for: Int(shop.shop_id))))
            print(shop.is_listing_sold_count_updated)
        }
    }
    
    func updateAllShops() {
        shopsInfo.removeAll()
        listingsCountHistory.removeAll()
        
        ShopDataManager.shared.updateAllShops().forEach { shop in
            shopsInfo.append(ShopInfo(shop: shop))
            
            updateActiveListingsFor.append(Int(shop.shop_id))
            listingsCountHistory.append(ListingsCountHistoryInfo(history: ShopDataManager.shared.getListingsCountHistory(for: Int(shop.shop_id))))
        }
        //print(updateActiveListingsFor)
        
    }
    
    func udpateShopSoldListingCount(id: Int, idInShops: Int) {
        
        self.shopsInfo[idInShops] = ShopInfo(shop: ShopDataManager.shared.updateShopSoldListingCount(id: id))
        self.shopsInfo[idInShops].is_listing_sold_count_updated = true
        self.listingsCountHistory[idInShops] = ListingsCountHistoryInfo(history: ShopDataManager.shared.getListingsCountHistory(for: Int(id)))
       // self.listingsCountHistory[idInShops].soldListingsCount = Int16(self.shopsInfo[idInShops].listing_sold_count)
    }
    
    func updateAllShopsSoldListingsCount() {
            for idx in 0..<shopsInfo.count {
                DispatchQueue.global(qos: .background).async { [weak self] in
               // self!.udpateShopSoldListingCount(id: Int(self!.shopsInfo[idx].shop_id!), idInShops: idx)
                let tempShopsInfo = ShopInfo(shop: ShopDataManager.shared.updateShopSoldListingCount(id: Int(self!.shopsInfo[idx].shop_id!)))
                DispatchQueue.main.async {
                    self!.shopsInfo[idx] = tempShopsInfo
                    self!.shopsInfo[idx].is_listing_sold_count_updated = true
                    self!.listingsCountHistory[idx] = ListingsCountHistoryInfo(history: ShopDataManager.shared.getListingsCountHistory(for: Int(tempShopsInfo.shop_id!)))
                }
            }
        }
    }

    func updateShopsAfterNew() {
            let shops = ShopDataManager.shared.getAllShops()
            if shops.count > shopsInfo.count {
                shopsInfo.append(ShopInfo(shop: ShopDataManager.shared.updateShopSoldListingCount(id: Int(shops.last!.shop_id))))
                shopsInfo[shopsInfo.count - 1].is_listing_sold_count_updated = true
                listingsCountHistory.append(ListingsCountHistoryInfo(history: ShopDataManager.shared.getListingsCountHistory(for: Int(shopsInfo[shopsInfo.count - 1].shop_id!))))
                //getListingsCountHistory()
                //listingsCountHistory.append(ListingsCountHistoryInfo(shopInfo: shopsInfo[shopsInfo.count - 1]))
            }
        
    }
    
    func updateAllShopsActiveListings() {
       
    }
    
    init() {
        
    }
}



