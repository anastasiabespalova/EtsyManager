//
//  ShopFeedViewModel.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 04.08.2021.
//

import Foundation

class ShopFeedViewModel: ObservableObject {
    
    var shopId: String = ""
    @Published var shopStruct = ShopInfo()
    
    
}
