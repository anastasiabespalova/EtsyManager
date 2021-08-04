//
//  ShopPreviewViewModel.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 03.08.2021.
//

import Foundation
import CoreData

class ShopPreviewViewModel: ObservableObject {
    
    var title: String = ""
    @Published var shops: [Shop] = []
    
    @Published var shopNames: [ShopPreviewModel] = []
    
    func getAllShops() {
        shops = ShopDataManager.shared.getAllShops()
    }
    
    init() {
        //ShopDataManager.shared.loadAllShops()
        shops = ShopDataManager.shared.getAllShops()
        print("Loaded shops quantity: \(shops.count)")
    }
}


struct ShopPreviewModel {
    
    let shop: Shop
    
    var id: NSManagedObjectID {
        return shop.objectID
    }
    
    var shop_name: String {
        return shop.shop_name ?? ""
    }
    
}

