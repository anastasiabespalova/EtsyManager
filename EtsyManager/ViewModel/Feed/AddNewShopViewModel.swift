//
//  AddNewShopViewModel.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 03.08.2021.
//

import Foundation

class AddNewShopViewModel: ObservableObject {
    
    var shopId: String = ""
    var isDigit = true
    //@Published var shopStruct = ShopInfo()
    
    func addNewShop() {
        if let shopIdInt = Int(shopId) {
           
                ShopDataManager.shared.loadShopWithId(shopIdInt)
            
        }
    }
}
