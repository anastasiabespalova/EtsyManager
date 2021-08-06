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
    
    func addNewShop() -> Bool {
        if let shopIdInt = Int(shopId) {
           // TODO: write down correct return value (if INT wasn't correct shop id)
                ShopDataManager.shared.loadShopWithId(shopIdInt)
            return true
        } else {
            return false
        }
    }
}
