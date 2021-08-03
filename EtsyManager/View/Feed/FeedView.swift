//
//  FeedView.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 02.08.2021.
//

import SwiftUI

struct FeedView: View {
    
    @State private var showFilters = false
    
    private let shopManager = ShopManager()

    var body: some View {
        
        NavigationView {
            List {
                //HeaderView(count: shopManager.shops.count)
                ForEach(shopManager.shops, id: \.name) { shop in
                ZStack {
                    NavigationLink(destination: ShopFeedPage()) {
                        EmptyView()
                    }
                    .opacity(0)
                    //.buttonStyle(PlainButtonStyle())
                    ShopView(shop: shop)
                }
                .frame(
                  maxWidth: .infinity,
                  maxHeight: .infinity,
                  alignment: .leading)
                .listRowInsets(EdgeInsets())
                .padding(.top, 8)
                //.padding([.leading, .trailing], 20)
                .background(Color.white)
            }
          }
            .navigationTitle("Shops")
            .toolbar {
            ToolbarItem {
              // swiftlint:disable:next multiple_closures_with_trailing_closure
              Button(action: { showFilters = true }) {
                Image(systemName: "line.horizontal.3.decrease.circle")
                  .accessibilityLabel(Text("Shows filter options"))
              }
            }
          }
          .sheet(isPresented: $showFilters) {
            FilterOptionsView()
          }
        }
        .navigationViewStyle(StackNavigationViewStyle())
     
    }
    
    init() {
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
