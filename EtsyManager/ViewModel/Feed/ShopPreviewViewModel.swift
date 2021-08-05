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
    @Published var shopChanges: [ShopChanges] = []
    
    func getAllShops() {
        shopsInfo.removeAll()
        ShopDataManager.shared.getAllShops().forEach { shop in
            shopsInfo.append(ShopInfo(shop: shop))
            print(shop.is_listing_sold_count_updated)
        }
    }
    
    func updateAllShops() {
        shopsInfo.removeAll()
        ShopDataManager.shared.updateAllShops().forEach { shop in
            shopsInfo.append(ShopInfo(shop: shop))
        }
    }
    
    func udpateShopSoldListingCount(id: Int, idInShops: Int) {
            self.shopsInfo[idInShops] = ShopInfo(shop: ShopDataManager.shared.updateShopSoldListingCount(id: id))
            self.shopsInfo[idInShops].is_listing_sold_count_updated = true
    }
    
    func updateAllShopsSoldListingsCount() {
            for idx in 0..<shopsInfo.count {
                DispatchQueue.global(qos: .background).async { [weak self] in
               // self!.udpateShopSoldListingCount(id: Int(self!.shopsInfo[idx].shop_id!), idInShops: idx)
                let tempShopsInfo = ShopInfo(shop: ShopDataManager.shared.updateShopSoldListingCount(id: Int(self!.shopsInfo[idx].shop_id!)))
                DispatchQueue.main.async {
                    self!.shopsInfo[idx] = tempShopsInfo
                    self!.shopsInfo[idx].is_listing_sold_count_updated = true
                }
            }
            
        }
    }

    func updateShopsAfterNew() {
            let shops = ShopDataManager.shared.getAllShops()
            if shops.count > shopsInfo.count {
                shopsInfo.append(ShopInfo(shop: ShopDataManager.shared.updateShopSoldListingCount(id: Int(shops.last!.shop_id))))
                shopsInfo[shopsInfo.count - 1].is_listing_sold_count_updated = true
            }
        
    }
    
    func updateAllShopsActiveListings() {
       
    }
    
    init() {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async { [weak self] in
                self?.updateAllShopsSoldListingsCount()
                self!.updateAllShopsActiveListings()
                
            }
        }
    }
}



