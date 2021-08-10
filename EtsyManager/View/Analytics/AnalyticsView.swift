//
//  AnalyticsView.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 02.08.2021.
//

import SwiftUI

struct AnalyticsView: View {
    var body: some View {
        VStack {
            Text("Analytics")
                .padding()
            button
        }
        
    }
    
    var button: some View {
        Button("Restart") {
            withAnimation {
                _ = EtsyAPI()
                //getShopId(for: "MilenArtShop")
                //etsy.getShopInfo(for: 27991754)
                //etsy.getlistin
               // ShopDataManager.shared.loadAllActiveListings(id: 27991754)
            }
        }
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView()
    }
}
