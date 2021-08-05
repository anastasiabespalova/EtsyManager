//
//  ActiveListingsViewModel.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 04.08.2021.
//

import SwiftUI
import CoreData

class ActiveListingsViewModel: ObservableObject {

    @Published var activeListingsInfo: [ListingInfo] = []
    var shopIds: [Int] = []
    @Published var totalActiveListingsInfo: [[ListingInfo]] = [[]]
    
    func getActiveListings(shopId: Int) {
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let listings = ShopDataManager.shared.getActiveListingsForShop(id: shopId)
        
        DispatchQueue.main.async {
            self!.activeListingsInfo.removeAll()
            for index in 0..<listings.count {
                self!.activeListingsInfo.append(ListingInfo(listing: listings[index]))
            }
        }
        }
    }
    
    // update existing listings
    func getActiveListingsForShop(shopId: Int) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let listings = ShopDataManager.shared.getActiveListingsForShop(id: shopId)
        
            DispatchQueue.main.async { [self] in
            
            var index: Int
            if self!.shopIds.contains(shopId) == true {
                index = self!.shopIds.firstIndex(of: shopId)!
                self!.totalActiveListingsInfo[index].removeAll()
                for ind in 0..<listings.count {
                    self!.totalActiveListingsInfo[index].append(ListingInfo(listing: listings[ind]))
                }
            } else {
                self!.shopIds.append(shopId)
                index = self!.shopIds.count - 1
                self!.totalActiveListingsInfo.append([])
                for ind in 0..<listings.count {
                    self!.totalActiveListingsInfo[index].append(ListingInfo(listing: listings[ind]))
                }
            }
        }
        }
    }
    
    func updateAllActiveListings(shopInfos: [ShopInfo]) {
        shopInfos.forEach { shop in
            if shopIds.contains(shop.shop_id!) == false {
                shopIds.append(shop.shop_id!)
                let index = shopIds.count - 1
                totalActiveListingsInfo.append([])
                
                let listings = ShopDataManager.shared.getActiveListingsForShop(id: shop.shop_id!)
                for ind in 0..<listings.count {
                    totalActiveListingsInfo[index].append(ListingInfo(listing: listings[ind]))
                }
            }
        }
    }
    
    //load active listings from memory
    func loadActiveListings(shopId: Int) {
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let listings = ShopDataManager.shared.loadActiveListingsForShop(id: shopId)
        
        DispatchQueue.main.async {
            self!.activeListingsInfo.removeAll()
            for index in 0..<listings.count {
                self!.activeListingsInfo.append(ListingInfo(listing: listings[index]))
            }
        }
        }
    }
    
    func resetAllRecords() {
        ShopDataManager.shared.resetAllRecords()
    }
    
    func getShopIndex(shopId: Int) -> Int {
        return shopIds.firstIndex(of: shopId) ?? 0
    }
    
    init() {
        
    }
    
    
    
  /*  init(shopId: Int) {
        self.shopId = shopId
        getActiveListings(shopId: self.shopId)
    } */
}
