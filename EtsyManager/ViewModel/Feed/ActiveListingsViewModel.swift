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
    
    @State var filter = UserDefaults.standard.string(forKey: "ActiveListingsFilter")
    
    
    
    func sortByViews() {
        activeListingsInfo.sort {
            $0.views > $1.views
        }
    }
    
    func sortByRecentAdded() {
        activeListingsInfo.sort {
            $0.creation_tsz > $1.creation_tsz
        }
    }
    
    func sortByHighestPrice() {
        activeListingsInfo.sort {
            Float($0.price)! > Float($1.price)!
        }
    }
    
    func sortByLowestPrice() {
        activeListingsInfo.sort {
            Float($0.price)! < Float($1.price)!
        }
    }
    
    func sortByFavorers() {
        activeListingsInfo.sort {
            $0.num_favorers > $1.num_favorers
        }
    }
    
    func filterActiveListings() {
        
        switch filter {
        case "Recent Added": sortByRecentAdded()
        case "Highest Price": sortByHighestPrice()
        case "Lowest Price": sortByLowestPrice()
        case "Most Favorers": sortByFavorers()
        case "Most Views": sortByViews()
        default: sortByRecentAdded()
        }
    }
    
    func getActiveListings(shopId: Int) {

        let listings = ShopDataManager.shared.getActiveListingsForShop(id: shopId)
        activeListingsInfo.removeAll()
                    for index in 0..<listings.count {
                        activeListingsInfo.append(ListingInfo(listing: listings[index]))
                    }
        filterActiveListings()
    }
    
    
    
    //load active listings from memory
    func loadActiveListings(shopId: Int) {

            let listings = ShopDataManager.shared.loadActiveListingsForShop(id: shopId)
        
            activeListingsInfo.removeAll()
            for index in 0..<listings.count {
                activeListingsInfo.append(ListingInfo(listing: listings[index]))
            }
        filterActiveListings()
        
    }
    
    func resetAllRecords() {
        ShopDataManager.shared.resetAllListings()
    }

    init() {
        
    }

}
