//
//  SoldListingsViewModel.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 11.08.2021.
//

import SwiftUI
import CoreData

class SoldListingsViewModel: ObservableObject {
    @State var filter = UserDefaults.standard.string(forKey: "SoldListingsFilter")

    @Published var soldListingsInfo: [ListingInfo] = []
    
    func sortByViews() {
        soldListingsInfo.sort {
            $0.views > $1.views
        }
    }
    
    func sortByRecentAdded() {
        soldListingsInfo.sort {
            $0.creation_tsz > $1.creation_tsz
        }
    }
    
    func sortByHighestPrice() {
        soldListingsInfo.sort {
            Float($0.price)! > Float($1.price)!
        }
    }
    
    func sortByLowestPrice() {
        soldListingsInfo.sort {
            Float($0.price)! < Float($1.price)!
        }
    }
    
    func sortByFavorers() {
        soldListingsInfo.sort {
            $0.num_favorers > $1.num_favorers
        }
    }
    
    
    func filterSoldListings() {
        
        switch filter {
        case "Recent Added": sortByRecentAdded()
        case "Highest Price": sortByHighestPrice()
        case "Lowest Price": sortByLowestPrice()
        case "Most Favorers": sortByFavorers()
        case "Most Views": sortByViews()
        default: sortByRecentAdded()
        }
    }
    
    func getSoldListings(shopId: Int) {

        let listings = ShopDataManager.shared.getAllInactiveListingsForShop(id: shopId)
        soldListingsInfo.removeAll()
                    for index in 0..<listings.count {
                        soldListingsInfo.append(ListingInfo(listing: listings[index]))
                    }
        filterSoldListings()
    }
    
  /*  func getShopIndex(shopId: Int) -> Int {
        return shopIds.firstIndex(of: shopId) ?? 0
    }*/
    
    init() {
        
    }

}
