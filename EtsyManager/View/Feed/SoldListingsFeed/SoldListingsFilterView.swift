//
//  SoldListingsFilterView.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 14.08.2021.
//

import SwiftUI

struct SoldListingsFilterView: View {
    @State private var animationAmount: CGFloat = 1
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.verticalSizeClass) var sizeClass
    
    @State var values:[CGFloat] = [0,0,1,2,3,4,7,4,5,6,10,5,3,2,1,0,0,1,2,1,0,0,5,0,1,2,0,0,0,0,0,0,0]
        
    @State var pos1:CGFloat = 0.0
    @State var pos2:CGFloat = 1.0

    @State var activeColor:Color = .black
    @State var inactiveColor:Color = .gray
    
    @State var selectedFilter: String
    

    var body: some View {
        VStack {
            VStack {
                Spacer()
                HStack {
                    Text("Filters for sold listings")
                        .fontWeight(.heavy)
                       // .font(.title)
                    Button("Discharge") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                    .font(.caption)
                    .foregroundColor(.black)
                    
                }
                Divider()
                Spacer()
            }//Intro VStack close
            .frame(maxWidth: .infinity, maxHeight: 100, alignment: .top)
            
            VStack (spacing: 30) {
                HStack {
                    Spacer()
                           Text("Sort by")
                               .font(Font.headline)
                        Spacer()
                           SoldListingsRadioButtonGroups { selected in
                            selectedFilter = selected
                           }
                    Spacer()
                }//HStack 1
                .padding([.leading, .trailing], 10)
                Divider()
                VStack(spacing: 30) {
                    Text("Price filter")
                        .font(Font.headline)
                    GeometryReader { geometry in
                        ZStack(alignment: .center) {
                            // Bar Graph
                            BarGraph(values: self.values, pos1: self.$pos1, pos2: self.$pos2, activeColor: self.activeColor, inactiveColor: self.inactiveColor)

                            // ComboSlider
                            ComboSlider(inactiveColor: self.inactiveColor, activeColor: self.activeColor, pos1: self.$pos1, pos2: self.$pos2)
                                .position(x: geometry.size.width/2.0, y: geometry.size.height + 5)

                        }
                    }
                    .frame(width: nil, height: 100, alignment: .center)
                                   .padding(.horizontal, 25)
                }
                
            }//VStack for 3 criterias
             .padding([.leading, .trailing], 20)
                 Spacer()

              // button moved from here into below background view !!

            }.background(BottomView(presentation: presentationMode) {
             Button {
                 presentationMode.wrappedValue.dismiss()
                 UserDefaults.standard.set(true, forKey: "LaunchedBefore")
                 UserDefaults.standard.set(selectedFilter, forKey: "SoldListingsFilter")
             } label: {
                 Text("Apply")
                     .fontWeight(.medium)
                     .padding([.top, .bottom], 15)
                     .padding([.leading, .trailing], 90)
                     .background(Color.black)
                     .foregroundColor(.white)
                     .cornerRadius(15)
                    .scaledToFill()
             }

            })
            //Main VStack
    }
}


enum SoldListingsSortBy: String {
    case recent = "Recent Added"
    case highestPrice = "Highest Price"
    case lowestPrice = "Lowest Price"
    case mostFavorers = "Most Favorers"
    case mostView = "Most Views"
}

struct SoldListingsRadioButtonGroups: View {
    let callback: (String) -> ()
    
  //  @State var selectedId: String = ""
    @State var selectedId = UserDefaults.standard.string(forKey: "SoldListingsFilter")
    
    var body: some View {
        VStack {
            radioRecentMajority
            radioHighestPriceMajority
            radioLowestPriceMajority
            radioMostFavorersMajority
            radioMostViewsMajority
        }
    }
    
    var radioRecentMajority: some View {
        RadioButtonField(
            id: SoldListingsSortBy.recent.rawValue,
            label: SoldListingsSortBy.recent.rawValue,
            isMarked: selectedId == SoldListingsSortBy.recent.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    var radioHighestPriceMajority: some View {
        RadioButtonField(
            id: SoldListingsSortBy.highestPrice.rawValue,
            label: SoldListingsSortBy.highestPrice.rawValue,
            isMarked: selectedId == SoldListingsSortBy.highestPrice.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    var radioLowestPriceMajority: some View {
        RadioButtonField(
            id: SoldListingsSortBy.lowestPrice.rawValue,
            label: SoldListingsSortBy.lowestPrice.rawValue,
            isMarked: selectedId == SoldListingsSortBy.lowestPrice.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    var radioMostFavorersMajority: some View {
        RadioButtonField(
            id: SoldListingsSortBy.mostFavorers.rawValue,
            label: SoldListingsSortBy.mostFavorers.rawValue,
            isMarked: selectedId == SoldListingsSortBy.mostFavorers.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    var radioMostViewsMajority: some View {
        RadioButtonField(
            id: SoldListingsSortBy.mostView.rawValue,
            label: SoldListingsSortBy.mostView.rawValue,
            isMarked: selectedId == SoldListingsSortBy.mostView.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    func radioGroupCallback(id: String) {
        selectedId = id
        callback(id)
    }
}
