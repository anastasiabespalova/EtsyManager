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
  //  @Published var totalActiveListingsInfo: [[ListingInfo]] = [[]]
    
    func getActiveListings(shopId: Int) {

        let listings = ShopDataManager.shared.getActiveListingsForShop(id: shopId)
        activeListingsInfo.removeAll()
                    for index in 0..<listings.count {
                        activeListingsInfo.append(ListingInfo(listing: listings[index]))
                    }
    }
    
    //load active listings from memory
    func loadActiveListings(shopId: Int) {

            let listings = ShopDataManager.shared.loadActiveListingsForShop(id: shopId)
        
            activeListingsInfo.removeAll()
            for index in 0..<listings.count {
                activeListingsInfo.append(ListingInfo(listing: listings[index]))
            }
    }
    
    func resetAllRecords() {
        ShopDataManager.shared.resetAllListings()
    }
    
    func getShopIndex(shopId: Int) -> Int {
        return shopIds.firstIndex(of: shopId) ?? 0
    }
    
    init() {
        
    }

}
