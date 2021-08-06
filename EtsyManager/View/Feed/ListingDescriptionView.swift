//
//  ListingDesriptionView.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 05.08.2021.
//

import SwiftUI

struct ListingDescriptionView: View {
    @Binding var listingInfo: ListingInfo
        @State var index = 0

        var images = ["SampleListingImage1", "SampleListingImage2"]

        var body: some View {
            ScrollView {
                VStack(spacing: 20) {
                    PagingView(index: $index.animation(), maxIndex: images.count - 1) {
                        ForEach(self.images, id: \.self) { imageName in
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                        }
                    }
                    .aspectRatio(4/3, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .frame(
                          alignment: .topLeading
                        )

                    Text(convertSpecialCharacters(string: listingInfo.title))
                    Text("Price: \(listingInfo.price)")
                    Text("Tags: \(listingInfo.tags)")
                    Text(convertSpecialCharacters(string: listingInfo.listing_description))
                    Text("Views: \(listingInfo.views)")
                    Text("Favorers: \(listingInfo.num_favorers)")
                    Text("Quantity: \(listingInfo.quantity)")
                }
                .padding()
            }
            
        }
    }

