//
//  ListingDesriptionView.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 05.08.2021.
//

import SwiftUI

struct ListingDescriptionView: View {
    @Binding var listingInfo: ListingInfo
    var body: some View {
        Text("Info about \(listingInfo.title)")
    }
}

