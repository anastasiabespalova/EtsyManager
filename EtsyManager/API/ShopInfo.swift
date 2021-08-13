//
//  ShopInfo.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 03.08.2021.
//

import Foundation

struct ShopInfo: Codable, Hashable, Identifiable, Comparable {
    var id: Int { shop_id ?? 0}
    
    var shop_id: Int?
    var creation_tsz: Float
    var digital_listing_count: Int
    var digital_sale_message: String
    var icon_url_fullxfull: String
    var last_modified_tsz: Float
    var listing_active_count: Int
    var listing_inactive_count: Int
    var listing_sold_count: Int
    var sale_message: String
    var shop_name: String
    var is_listing_sold_count_updated: Bool
    
    static func < (lhs: ShopInfo, rhs: ShopInfo) -> Bool {
        lhs.last_modified_tsz < rhs.last_modified_tsz
    }
    
    init() {
        shop_id = nil
        creation_tsz = 0
        digital_listing_count = 0
        digital_sale_message = ""
        icon_url_fullxfull = ""
        last_modified_tsz = 0
        listing_active_count = 0
        listing_inactive_count = 0
        listing_sold_count = 0
        sale_message = ""
        shop_name = ""
        is_listing_sold_count_updated = false
    }
    
    init(shop: Shop) {
        self.shop_id = Int(shop.shop_id)
        self.creation_tsz = shop.creation_tsz
        self.digital_listing_count = Int(shop.digital_listing_count)
        self.digital_sale_message = shop.digital_sale_message ?? ""
        self.icon_url_fullxfull = shop.icon_url_fullxfull ?? ""
        self.last_modified_tsz = shop.last_modified_tsz
        self.listing_active_count = Int(shop.listing_active_count)
        self.listing_inactive_count = Int(shop.listing_inactive_count)
        self.listing_sold_count = Int(shop.listing_sold_count)
        self.sale_message = shop.sale_message ?? ""
        self.shop_name = shop.shop_name ?? ""
        self.is_listing_sold_count_updated = shop.is_listing_sold_count_updated
    }
}
