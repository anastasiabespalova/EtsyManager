//
//  ContentView.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 02.08.2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        MainTabView()
            .environment(\.managedObjectContext, context)
    }
    

}
