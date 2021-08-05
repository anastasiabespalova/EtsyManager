//
//  ListingInfo.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 04.08.2021.
//

import Foundation

struct ListingInfo: Codable, Hashable, Identifiable, Comparable {
    var id: Int { listing_id }
    
    var creation_tsz: Float
    var is_digital: Bool
    var is_private: Bool
    var item_dimensions_unit: String
    var item_height: Int
    var item_width: Int
    var last_modified_tsz: Float
    var listing_description: String
    var listing_id: Int
    var num_favorers: Int
    var price: String
    var quantity: Int
    var state: String
    var tags: String
    var title: String
    var views: Int
    
    var shop_id: Int
   
    
    static func < (lhs: ListingInfo, rhs: ListingInfo) -> Bool {
        lhs.last_modified_tsz < rhs.last_modified_tsz
    }
    
    init() {
        creation_tsz = 0
        is_digital = false
        is_private = false
        item_dimensions_unit = ""
        item_height = 0
        item_width = 0
        last_modified_tsz = 0
        listing_description = ""
        listing_id = 0
        num_favorers = 0
        price = ""
        quantity = 0
        state = ""
        tags = ""
        title = ""
        views = 0
        shop_id = 0
    }
    
    init(listing: Listing) {
        self.listing_id = Int(listing.listing_id)
        self.creation_tsz = listing.creation_tsz
        self.is_digital = listing.is_digital
        self.is_private = listing.is_private
        self.item_dimensions_unit = listing.item_dimensions_unit ?? ""
        self.item_height = Int(listing.item_height)
        self.item_width = Int(listing.item_width)
        self.last_modified_tsz = listing.last_modified_tsz
        self.listing_description = listing.listing_description ?? ""
        self.num_favorers = Int(listing.num_favorers)
        self.price = listing.price ?? ""
        self.quantity = Int(listing.quantity)
        self.state = listing.state ?? ""
        self.tags = listing.tags ?? ""
        self.title = listing.title ?? ""
        self.views = Int(listing.views)
        self.shop_id = Int(listing.fromShop.shop_id)
    }
    
    
    
}
