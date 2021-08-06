//
//  RadioButton.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 06.08.2021.
//

import SwiftUI

struct RadioButtonField: View {
    let id: String
    let label: String
    let size: CGFloat
    let color: Color
    let textSize: CGFloat
    let isMarked:Bool
    let callback: (String)->()
    
    init(
        id: String,
        label:String,
        size: CGFloat = 20,
        color: Color = Color.black,
        textSize: CGFloat = 14,
        isMarked: Bool = false,
        callback: @escaping (String)->()
        ) {
        self.id = id
        self.label = label
        self.size = size
        self.color = color
        self.textSize = textSize
        self.isMarked = isMarked
        self.callback = callback
    }
    
    var body: some View {
        Button(action:{
            self.callback(self.id)
        }) {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: self.isMarked ? "largecircle.fill.circle" : "circle")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: self.size, height: self.size)
                Text(label)
                    .font(Font.system(size: textSize))
                Spacer()
            }.foregroundColor(self.color)
        }
        .foregroundColor(Color.white)
    }
}

/*enum Gender: String {
    case male = "Male"
    case female = "Female"
}*/

enum SortBy: String {
    case recent = "Recent Added"
    case highestPrice = "Highest Price"
    case lowestPrice = "Lowest Price"
    case mostFavorers = "Most Favorers"
    case mostView = "Most Views"
}

struct RadioButtonGroups: View {
    let callback: (String) -> ()
    
    @State var selectedId: String = ""
    
    var body: some View {
        VStack {
           // radioMaleMajority
           // radioFemaleMajority
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
    
   /* var radioMaleMajority: some View {
        RadioButtonField(
            id: Gender.male.rawValue,
            label: Gender.male.rawValue,
            isMarked: selectedId == Gender.male.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    var radioFemaleMajority: some View {
        RadioButtonField(
            id: Gender.female.rawValue,
            label: Gender.female.rawValue,
            isMarked: selectedId == Gender.female.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    */
    
    func radioGroupCallback(id: String) {
        selectedId = id
        callback(id)
    }
}
