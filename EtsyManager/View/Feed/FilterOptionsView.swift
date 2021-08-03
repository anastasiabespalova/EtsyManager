//
//  FilterOptionsView.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 02.08.2021.
//

import SwiftUI

struct FilterOptionsView: View {
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var store: ShopManager

  var body: some View {
   Text("Some filters here")
  }
}
/*
struct FilterOptionsView_Previews: PreviewProvider {
  static var previews: some View {
    FilterOptionsView()
      .environmentObject(EpisodeStore())
  }
}
*/
