//
//  ListingView.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 05.08.2021.
//

import SwiftUI

struct ListingView: View {
  //  @ObservedObject var shop: Shop
  //let shop: ShopExample
   // @ObservedObject var shop: Shop
    @Binding var listingInfo: ListingInfo

  var body: some View {
    VStack {
        HStack(alignment: .top, spacing: 0) {
            Spacer()
            ListingIcon(width: 120, height: 90, radius: 6)
            Spacer()
            VStack(alignment: .leading, spacing: 6) {
                //Text(shop.name)
                Text(convertSpecialCharacters(string: listingInfo.title))
            }
                .padding(.horizontal)
                .font(.footnote)
            .foregroundColor(.black)
            Spacer()
        }
        VStack {
            HStack {
                Text("Price: \(listingInfo.price)")
                Text("Quantity: \(listingInfo.quantity)")
            }
            HStack {
                Text("Favorers: \(listingInfo.num_favorers)")
                Text("Views: \(listingInfo.views)")
            }
        }
        .font(.caption)
        
       
    }
   
    .frame(minWidth: 0, maxWidth: .infinity)
    .padding(10)
    .background(Color.white)
    .cornerRadius(15)
    .shadow(color: Color.black.opacity(0.1), radius: 10)
    .padding([.leading, .trailing], 20)
  }
}

