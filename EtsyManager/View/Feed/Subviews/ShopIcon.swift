//
//  ShopIcon.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 02.08.2021.
//


import SwiftUI
import Kingfisher

struct ShopIcon: View {
  let width: CGFloat
  let height: CGFloat
  let radius: CGFloat
    @Binding var shopIconURL: String
    
    let gradientColors = Gradient(
      colors: [Color.gradientDark, Color.gradientLight])

  var body: some View {
    ZStack {
      //RoundedRectangle(cornerRadius: radius)
      //  .fill(Color.gradientDark)
       // .frame(width: width, height: height)
        //Image("SampleShopImage2")
        KFImage(URL(string: shopIconURL) ?? URL(string: "http://cdn.onlinewebfonts.com/svg/img_61838.png"))
            .resizable()
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 1))
           // .shadow(radius: 10)
       // .font(.title)
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
/*
struct ShopIcon_Previews: PreviewProvider {
  static var previews: some View {
    ShopIcon(width: 50, height: 50, radius: 10)
      .previewLayout(.sizeThatFits)
  }
}
*/
