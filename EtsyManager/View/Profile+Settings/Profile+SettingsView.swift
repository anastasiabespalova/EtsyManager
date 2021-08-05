//
//  Profile+SettingsView.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 02.08.2021.
//

import SwiftUI

struct Profile_SettingsView: View {

        var body: some View {
            VStack {
                HStack {
                    Button("Save") {
                    }
                }
                Spacer()
            }.padding()
            .onAppear(perform: {
                //taskListVM.getAllTasks()
            })
            
        }
}

struct Profile_SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Profile_SettingsView()
    }
}
