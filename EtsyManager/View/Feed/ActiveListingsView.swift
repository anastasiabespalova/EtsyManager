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
    @EnvironmentObject var activeListings: ActiveListingsViewModel
    
    var body: some View {
    
        //List {
        List {
                        ForEach(activeListings.activeListingsInfo.indices, id: \.self) { idx in
                ZStack {
                    NavigationLink( destination: ListingDescriptionView(listingInfo: $activeListings.activeListingsInfo[idx]) ) {
                        EmptyView()
                    }
                    .opacity(0)
                 ListingView(listingInfo: $activeListings.activeListingsInfo[idx])
                    Text("From shop \(activeListings.activeListingsInfo[idx].shop_id)")
                }
                .frame(
                  maxWidth: .infinity,
                  maxHeight: .infinity,
                  alignment: .leading)
                .listRowInsets(EdgeInsets())
                .padding(.top, 8)
                .background(Color.white)
            }
        }
    
        .onAppear() {

            
            
            
        }
    
    }

}
