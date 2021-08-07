//
//  ShopFeedPage.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 02.08.2021.
//

import SwiftUI

struct ShopFeedPage: View {
    
    @Binding var shopInfo: ShopInfo
    @State private var currentTab = 0
    @State private var showFilters = false
    
    @Binding var updateActiveListingsFor: [Int]
    
    @ObservedObject var activeListings: ActiveListingsViewModel = ActiveListingsViewModel()
    
    var body: some View {
        VStack {
            TabView(selection: $currentTab,
                    content:  {
                        //ActiveListingsView(shopInfo: $shopInfo, activeListings: activeListings)
                        ActiveListingsView(shopInfo: $shopInfo)
                            .environmentObject(activeListings)
                            .tag(0)
                        SoldListingsView(shopInfo: $shopInfo)
                            .tag(1)
                    })
                
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                .navigationTitle("\(shopInfo.shop_name)")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showFilters = true }) {
                          Image(systemName: "line.horizontal.3.decrease.circle")
                            .accessibilityLabel(Text("Shows filter options"))
                        }
                           }
                }
                .sheet(isPresented: $showFilters) {
                 // FilterOptionsView()
                    ActiveListingsFilterView()
                }
               
                
        }
        .onAppear() {
            if updateActiveListingsFor.contains(shopInfo.shop_id!) {
                activeListings.getActiveListings(shopId: shopInfo.shop_id!)
                updateActiveListingsFor.remove(at: updateActiveListingsFor.firstIndex(of: shopInfo.shop_id!)!)
            } else {
                activeListings.loadActiveListings(shopId: shopInfo.shop_id!)
            }
         //   activeListings.resetAllRecords()
            
        }
     
        }
               
}

/*struct ShopFeedPage_Previews: PreviewProvider {
    static var previews: some View {
        ShopFeedPage()
    }
}
*/
