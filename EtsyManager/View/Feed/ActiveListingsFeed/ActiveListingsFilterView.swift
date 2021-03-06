//
//  ActiveListingsFilterView.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 06.08.2021.
//

import SwiftUI

struct ActiveListingsFilterView: View {
    @State private var animationAmount: CGFloat = 1
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.verticalSizeClass) var sizeClass
    
    @State var values:[CGFloat] = [0,0,1,2,3,4,7,4,5,6,10,5,3,2,1,0,0,1,2,1,0,0,5,0,1,2,0,0,0,0,0,0,0]
        
    @State var pos1:CGFloat = 0.0
    @State var pos2:CGFloat = 1.0

    @State var activeColor:Color = .black
    @State var inactiveColor:Color = .gray
    
    @State var selectedFilter: String
    
    //@State var activeListings: ActiveListingsViewModel
    /*
    var values:[CGFloat] {
        let temp = [CGFloat]()
        for listing in activeListings {
            temp.append(CGFloat(Double(listing.price)))
        }
        return temp
        
    }
    */
    var body: some View {
        VStack {
            VStack {
                Spacer()
                HStack {
                    Text("Filters for active listings")
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
                           RadioButtonGroups { selected in
                            selectedFilter = selected
                           // UserDefaults.standard.set(selected, forKey: "ActiveListingsFilter")
                            
                               //print("Selected Gender is: \(selected)")
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
                 UserDefaults.standard.set(selectedFilter, forKey: "ActiveListingsFilter")
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


enum SortBy: String {
    case recent = "Recent Added"
    case highestPrice = "Highest Price"
    case lowestPrice = "Lowest Price"
    case mostFavorers = "Most Favorers"
    case mostView = "Most Views"
}

struct RadioButtonGroups: View {
    let callback: (String) -> ()
    
  //  @State var selectedId: String = ""
    @State var selectedId = UserDefaults.standard.string(forKey: "ActiveListingsFilter")
    
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
            id: SortBy.recent.rawValue,
            label: SortBy.recent.rawValue,
            isMarked: selectedId == SortBy.recent.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    var radioHighestPriceMajority: some View {
        RadioButtonField(
            id: SortBy.highestPrice.rawValue,
            label: SortBy.highestPrice.rawValue,
            isMarked: selectedId == SortBy.highestPrice.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    var radioLowestPriceMajority: some View {
        RadioButtonField(
            id: SortBy.lowestPrice.rawValue,
            label: SortBy.lowestPrice.rawValue,
            isMarked: selectedId == SortBy.lowestPrice.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    var radioMostFavorersMajority: some View {
        RadioButtonField(
            id: SortBy.mostFavorers.rawValue,
            label: SortBy.mostFavorers.rawValue,
            isMarked: selectedId == SortBy.mostFavorers.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    var radioMostViewsMajority: some View {
        RadioButtonField(
            id: SortBy.mostView.rawValue,
            label: SortBy.mostView.rawValue,
            isMarked: selectedId == SortBy.mostView.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    func radioGroupCallback(id: String) {
        selectedId = id
        callback(id)
    }
}
