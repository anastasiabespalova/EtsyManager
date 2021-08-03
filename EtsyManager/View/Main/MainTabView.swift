//
//  MainTabView.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 02.08.2021.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            FeedView()
                .tabItem {
                    Image(systemName: "house")
                }
            
            AnalyticsView()
                .tabItem {
                Image(systemName: "book")
            }
            
            
            Profile_SettingsView()
                .tabItem {
                Image(systemName: "slider.horizontal.3")
            }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
