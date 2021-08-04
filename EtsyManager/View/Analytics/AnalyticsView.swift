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
                let etsy = EtsyAPI()
                //etsy.getShopInfo(for: 27991754)
                getNumberOfSales(for: "MarinAmosovaPainting")
                getShopId(for: "MarinAmosovaPainting")
            }
        }
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView()
    }
}
