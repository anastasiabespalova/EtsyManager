//
//  AddNewShopView.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 03.08.2021.
//

import SwiftUI

struct AddNewShopView: View {
    @ObservedObject var newShop = AddNewShopViewModel()
    var body: some View {
        VStack {
            HStack {
                TextField("Enter shop id", text: $newShop.shopId)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Save") {
                   // taskListVM.save()
                    //taskListVM.getAllTasks()
                }
            }
            
          /*  List {
                ForEach(taskListVM.tasks, id: \.id) { task in
                    Text(task.title)
                }.onDelete(perform: deleteTask)
            }*/
            
            Spacer()
        }.padding()
        .onAppear(perform: {
            //taskListVM.getAllTasks()
        })
        .onDisappear(perform: {
            newShop.addNewShop()
        })
        
    }
}

