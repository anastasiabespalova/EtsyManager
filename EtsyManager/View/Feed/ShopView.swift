//
//  ShopView.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 02.08.2021.
//

import SwiftUI


struct ShopView: View {
  //  @ObservedObject var shop: Shop
    
  //let shop: ShopExample
    let shop: Shop

  var body: some View {
    HStack(alignment: .top, spacing: 0) {
        Spacer()
        ShopIcon(width: 40, height: 40, radius: 6)
        Spacer()
        VStack(alignment: .leading, spacing: 6) {
            //Text(shop.name)
            Text(shop.shop_name ?? "Default")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color(UIColor.label))
            AdaptingStack {
                Text("Active listings: " + String(shop.listing_active_count) + "  ")
               // Text(shop.released + "  ")
               // Text(shop.domain + "  ")
               // Text(String(shop.difficulty).capitalized)
            }
            Text("Sales: " + String(shop.listing_sold_count) + "  ")
            //Text(shop.description)
               // .lineLimit(2)
        }
            .padding(.horizontal)
            .font(.footnote)
            .foregroundColor(Color(UIColor.systemGray))
        Spacer()
    }
    .frame(minWidth: 0, maxWidth: .infinity)
    .padding(10)
    .background(Color.white)
    .cornerRadius(15)
    .shadow(color: Color.black.opacity(0.1), radius: 10)
    .padding([.leading, .trailing], 20)
  }
}

/*
struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView()
    }
}
*/
