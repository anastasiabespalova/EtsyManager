//
//  SoldListingsView.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 05.08.2021.
//

import SwiftUI

struct SoldListingsView: View {
    
    @Binding var shopInfo: ShopInfo
    @StateObject var soldListings: SoldListingsViewModel
    
    var body: some View {
        List {
           // ForEach(self.activeListings.activeListingsInfo.indices, id: \.self) { idx in
            ForEach(soldListings.soldListingsInfo, id: \.id) { soldListingInfo in
            //ForEach(activeListingsInfo, id: \.id) { activeListingInfo in
                ZStack {
                    //NavigationLink( destination: ListingDescriptionView(listingInfo: self.$activeListings.activeListingsInfo[idx]) ) {
                    NavigationLink( destination: ListingDescriptionView(listingInfo: soldListingInfo) ) {
                        EmptyView()
                    }
                    .opacity(0)
                    //ListingView(listingInfo: self.$activeListings.activeListingsInfo[idx])
                    ListingView(listingInfo: soldListingInfo)
                }
                .frame(
                  maxWidth: .infinity,
                  maxHeight: .infinity,
                  alignment: .leading)
                .listRowInsets(EdgeInsets())
                .padding(.top, 8)
                .background(Color.white)
                            
            }
            Text("Total sold listings: \(soldListings.soldListingsInfo.count)")
          //  Text("Total active listings: \(activeListingsInfo.count)")
                .font(.caption)
        }
    
        .onAppear() {

            
            
            
        }
    }
}


