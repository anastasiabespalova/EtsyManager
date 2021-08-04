//
//  ViewModel.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 02.08.2021.
//

import SwiftUI

class ShopManager: ObservableObject {
    
    init() {
        shops.append(ShopExample())
        shops.append(ShopExample())
        shops.append(ShopExample())
    }
    @Published var shops: Array<ShopExample> = []
}

struct ShopExample {
  let name: String = "TheThirdLayerShop"
  let description: String = "Here can be a description" // description_plain_text
  let released: String = "Sept 2019"  // released_at, will be Date
  let domain: String = "Puk"  // enum
  let difficulty: String = "Very much" // enum
  let videoURLString: String = "String here"  // will be videoIdentifier: Int
  let uri: String = "String here" // redirects to the real web page
  var linkURLString: String {
    "https://www.raywenderlich.com/redirect?uri=" + uri
  }
}
