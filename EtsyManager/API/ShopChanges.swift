//
//  ShopChanges.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 04.08.2021.
//

import Foundation

struct ShopChanges: Codable, Hashable, Identifiable {
    var id: Int?
    
    var shop_id: Int?
    var creation_tsz: Float?
    var digital_listing_count: Int?
    var digital_sale_message: String?
    var icon_url_fullxfull: String?
    var last_modified_tsz: Float?
    var listing_active_count: Int?
    var listing_inactive_count: Int?
    var listing_sold_count: Int?
    var sale_message: String?
    var shop_name: String?
    var is_listing_sold_count_updated: Bool?
    
    
}
