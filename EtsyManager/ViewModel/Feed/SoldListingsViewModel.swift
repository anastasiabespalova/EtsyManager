//
//  SoldListingsViewModel.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 11.08.2021.
//

import SwiftUI
import CoreData

class SoldListingsViewModel: ObservableObject {

    @Published var soldListingsInfo: [ListingInfo] = [] /*{
        willSet {
            objectWillChange.send()
        }
    } */
    var shopIds: [Int] = []
  //  @Published var totalActiveListingsInfo: [[ListingInfo]] = [[]]
    
    func getSoldListings(shopId: Int) {

        let listings = ShopDataManager.shared.getAllInactiveListingsForShop(id: shopId)
        soldListingsInfo.removeAll()
                    for index in 0..<listings.count {
                        soldListingsInfo.append(ListingInfo(listing: listings[index]))
                    }
    }
    
    func getShopIndex(shopId: Int) -> Int {
        return shopIds.firstIndex(of: shopId) ?? 0
    }
    
    init() {
        
    }

}
