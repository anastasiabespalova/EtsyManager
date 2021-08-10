//
//  AddNewShopViewModel.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 03.08.2021.
//

import Foundation

class AddNewShopViewModel: ObservableObject {
    
    var shopId: Int = 0
    var isDigit = true
    //@Published var shopStruct = ShopInfo()
    var shopName: String = ""
    
    func addNewShop() -> Bool {
       // if let shopIdInt = Int(shopId) {
        shopId = getShopId(for: shopName)
           // TODO: write down correct return value (if INT wasn't correct shop id)
        ShopDataManager.shared.loadShopWithId(shopId)
        return true
    }
}
