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
   // @ObservedObject var shop: Shop
    @Binding var shopInfo: ShopInfo
    @Binding var listingsCountHistoryInfo: ListingsCountHistoryInfo

  var body: some View {
    HStack(alignment: .top, spacing: 0) {
        Spacer()
        ShopIcon(width: 40, height: 40, radius: 6, shopIconURL: $shopInfo.icon_url_fullxfull)
        Spacer()
        VStack(alignment: .leading, spacing: 6) {
            
            VStack(alignment: .leading, spacing: 6) {
                //Text(shop.name)
                Text(shopInfo.shop_name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                   // .foregroundColor(Color(UIColor.label))
                
                HStack {
                    Text("Active listings:  \(shopInfo.listing_active_count) (\(Int(shopInfo.listing_active_count) - Int(listingsCountHistoryInfo.activeListingsCount)))" )
                if shopInfo.is_listing_sold_count_updated {
                    //Text("Sales: " + String(shopInfo.listing_sold_count) + "  (" + String(Int(shopInfo.listing_sold_count) - Int(listingsCountHistoryInfo.soldListingsCount)) + ")")
                    Text("Sales:  \(shopInfo.listing_sold_count) (\(Int(shopInfo.listing_sold_count) - Int(listingsCountHistoryInfo.soldListingsCount)))" )
                } else {
                    HStack {
                        Text("Sales: ")
                        ProgressView()
                    }
                   
                }
                }
            }
            
            
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
