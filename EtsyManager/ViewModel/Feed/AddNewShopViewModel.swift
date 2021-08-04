//
//  AddNewShopViewModel.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 03.08.2021.
//

import Foundation

class AddNewShopViewModel: ObservableObject {
    
    var shopId: String = ""
    @Published var shopStruct = ShopInfo()
    
    func addNewShop() {
        //ShopDataManager.shared.loadShopWithId(27991754)
        ShopDataManager.shared.loadShopWithId(27991754)
    }
}
