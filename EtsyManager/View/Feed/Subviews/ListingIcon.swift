//
//  ListingIcon.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 06.08.2021.
//

import SwiftUI
import Kingfisher

struct ListingIcon: View {
  let width: CGFloat
  let height: CGFloat
  let radius: CGFloat
    @Binding var listingImages: [ListingImageURLsInfo]
    
    let gradientColors = Gradient(
      colors: [Color.gradientDark, Color.gradientLight])

  var body: some View {
    ZStack {
      //RoundedRectangle(cornerRadius: radius)
      //  .fill(Color.gradientDark)
       // .frame(width: width, height: height)
        //Image("SampleListingImage1")
        KFImage(URL(string: listingImages.first?.url_570xN ?? "http://cdn.onlinewebfonts.com/svg/img_61838.png") ?? URL(string: "http://cdn.onlinewebfonts.com/svg/img_61838.png"))
            .resizable()
           // .frame(width: 120)
           // .clipShape(RoundedRectangle(cornerRadius: 5))
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 100)
            //.overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 1))
           // .shadow(radius: 10)
       // .font(.title)
        //.colorInvert()
    }
    
  }
}
