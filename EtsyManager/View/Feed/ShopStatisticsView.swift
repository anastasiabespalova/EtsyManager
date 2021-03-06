//
//  ShopStatisticsView.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 11.08.2021.
//
import SwiftUICharts
import SwiftUI

struct ShopStatisticsView: View {
   // @Binding var listingInfo: ListingInfo
    @Binding var shopInfo: ShopInfo

    var images = ["SampleListingImage1"]

    var body: some View {
            ScrollView {
                VStack {
                    Text(convertSpecialCharacters(string: shopInfo.shop_name))
                    Text("Active listings count: \(shopInfo.listing_active_count)")
                    Text("Sold listings count: \(shopInfo.listing_sold_count)")
                    Text("Inactive listings count: \(shopInfo.listing_inactive_count)")
                    
                    Text("Digital sale message: \(shopInfo.digital_sale_message)")
                    
                    Text("Sale message: \(shopInfo.sale_message)")
                    ForEach(ShopDataManager.shared.getAllListingsCountHistoryForShop(for: shopInfo.shop_id!)) { history in
                        Text("Active Listings: \(history.activeListingsCount)")
                        Text("Sold Listings: \(history.soldListingsCount)")
                    }
                   // MultiLineChartView(data: [([8,32,11,23,40,28], GradientColors.green), ([90,99,78,111,70,60,77], GradientColors.blue))
                    LineView(data: [8,23,54,32,12,37,7,23,43], title: "Line chart", legend: "Full screen")
                    //LineView(data: [([8,32,11,23,40,28], GradientColors.green), ([90,99,78,111,70,60,77], GradientColors.purple), ([34,56,72,38,43,100,50], GradientColors.orngPink)], title: "Title")
                    }
                .padding()
                }
           
              
            
    }
}
