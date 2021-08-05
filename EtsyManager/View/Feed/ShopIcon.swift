//
//  ShopIcon.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 02.08.2021.
//


import SwiftUI

struct ShopIcon: View {
  let width: CGFloat
  let height: CGFloat
  let radius: CGFloat
    
    let gradientColors = Gradient(
      colors: [Color.gradientDark, Color.gradientLight])

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: radius)
        .fill(Color.gradientDark)
        .frame(width: width, height: height)
      Image(systemName: "play.circle.fill")
        .font(.title)
        //.colorInvert()
    }
    
  }
}


extension Color {
  // Add app colors to standard colors
  static let gradientDark = Color("gradient-dark")
  static let gradientLight = Color("gradient-light")
  static let grayButton = Color("gray-button")
  static let greenButton = Color("green-button")
  static let closeBkgd = Color("close-bkgd")
  static let itemBkgd = Color("item-bkgd")
  static let listBkgd = Color("list-bkgd")
  static let topBkgd = Color("top-bkgd")
}

struct ShopIcon_Previews: PreviewProvider {
  static var previews: some View {
    ShopIcon(width: 50, height: 50, radius: 10)
      .previewLayout(.sizeThatFits)
  }
}
