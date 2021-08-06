//
//  ListingIcon.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 06.08.2021.
//

import SwiftUI

struct ListingIcon: View {
  let width: CGFloat
  let height: CGFloat
  let radius: CGFloat
    
    let gradientColors = Gradient(
      colors: [Color.gradientDark, Color.gradientLight])

  var body: some View {
    ZStack {
      //RoundedRectangle(cornerRadius: radius)
      //  .fill(Color.gradientDark)
       // .frame(width: width, height: height)
        Image("SampleListingImage1")
            .resizable()
            .frame(width: 120, height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            //.overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 1))
           // .shadow(radius: 10)
       // .font(.title)
        //.colorInvert()
    }
    
  }
}
