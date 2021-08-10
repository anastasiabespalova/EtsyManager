//
//  ActiveListingsView.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 04.08.2021.
//

import SwiftUI

struct ActiveListingsView: View {
 
    
    @Binding var shopInfo: ShopInfo
    // https://stackoverflow.com/questions/60956270/swiftui-view-not-updating-based-on-observedobject
    @StateObject var activeListings: ActiveListingsViewModel
    
    var body: some View {
        List {
           // ForEach(self.activeListings.activeListingsInfo.indices, id: \.self) { idx in
            ForEach(activeListings.activeListingsInfo, id: \.id) { activeListingInfo in
            //ForEach(activeListingsInfo, id: \.id) { activeListingInfo in
                ZStack {
                    //NavigationLink( destination: ListingDescriptionView(listingInfo: self.$activeListings.activeListingsInfo[idx]) ) {
                    NavigationLink( destination: ListingDescriptionView(listingInfo: activeListingInfo) ) {
                        EmptyView()
                    }
                    .opacity(0)
                    //ListingView(listingInfo: self.$activeListings.activeListingsInfo[idx])
                    ListingView(listingInfo: activeListingInfo)
                }
                .frame(
                  maxWidth: .infinity,
                  maxHeight: .infinity,
                  alignment: .leading)
                .listRowInsets(EdgeInsets())
                .padding(.top, 8)
                .background(Color.white)
                            
            }
            Text("Total active listings: \(activeListings.activeListingsInfo.count)")
          //  Text("Total active listings: \(activeListingsInfo.count)")
                .font(.caption)
        }
    
        .onAppear() {

            
            
            
        }
    }

}
