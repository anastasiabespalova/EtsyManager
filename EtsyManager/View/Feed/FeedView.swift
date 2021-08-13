//
//  FeedView.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 02.08.2021.
//

import SwiftUI

struct FeedView: View {
    
    @State private var isDone: Bool = true
    @State private var showFilters = false
    @State private var addNewShop = false
    @State private var shouldUpdate = false
    @ObservedObject private var shopList = ShopPreviewViewModel()

    
    var body: some View {
        
       // RefreshableNavigationView(title: "Numbers", action:{
        //            print("refresh")
       // }, isDone: $isDone) {
        NavigationView{
            List {
            
                ForEach(shopList.shopsInfo.indices, id: \.self) { idx in
                ZStack {
                    // NavigationLink( destination: ShopFeedPage(shopInfo: $shopList.shopsInfo[idx])) {
                    NavigationLink( destination:
                                        ShopFeedPage(shopInfo: $shopList.shopsInfo[idx],
                                                     updateActiveListingsFor: $shopList.updateActiveListingsFor))  {
                        EmptyView()
                    }
                    .opacity(0)
                    ShopView(shopInfo: $shopList.shopsInfo[idx], listingsCountHistoryInfo: $shopList.listingsCountHistory[idx])
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
            .navigationBarTitle("Shops Feed", displayMode: .inline)
            .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { addNewShop = true }) {
                  Image(systemName: "plus")
                    .accessibilityLabel(Text("Shows filter options"))
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showFilters = true }) {
                  Image(systemName: "line.horizontal.3.decrease.circle")
                    .accessibilityLabel(Text("Shows filter options"))
                }
                   }
          }
          .sheet(isPresented: $showFilters) {
            FilterOptionsView()
          }
        .sheet(isPresented: $addNewShop) {
             // AddNewShopView(isPresented: self.$addNewShop,
            AddNewShopView(
                             updateActiveListingsFor: $shopList.updateActiveListingsFor)
                .onDisappear() {
                    shopList.updateShopsAfterNew()
                    
                }
        }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {

        }
     
    }
    
    init() {
        shopList.updateAllShops()
        shopList.updateAllShopsSoldListingsCount()
        
        
        // 1. White title on black background
        let appearance = UINavigationBarAppearance()
       // appearance.backgroundColor = UIColor(named: "top-bkgd")
        appearance.largeTitleTextAttributes =
          [.foregroundColor: UIColor.black]
        appearance.titleTextAttributes =
          [.foregroundColor: UIColor.black]

        // 2. Back button text and arrow color
        UINavigationBar.appearance().tintColor = .black

        // 3. Assign configuration to all appearances
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance

        // 4. Selected segment color
        UISegmentedControl.appearance()
          .selectedSegmentTintColor = UIColor(named: "list-bkgd")
      }
    
    
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}

extension Binding where Value == Bool {
    var not: Binding<Value> {
        Binding<Value>(
            get: { !self.wrappedValue },
            set: { self.wrappedValue = !$0 }
        )
    }
}


