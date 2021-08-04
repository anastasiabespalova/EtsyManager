//
//  Profile+SettingsView.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 02.08.2021.
//

import SwiftUI

struct Profile_SettingsView: View {
    @StateObject private var taskListVM = CoreShopViewModel()
        
       /* func deleteTask(at offsets: IndexSet) {
            offsets.forEach { index in
                let task = taskListVM.tasks[index]
                taskListVM.delete(task)
            }
            
            taskListVM.getAllTasks()
        }*/
        
        var body: some View {
            VStack {
                HStack {
                    //TextField("Enter task name", text: $taskListVM.title)
                    //    .textFieldStyle(RoundedBorderTextFieldStyle())
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
            
        }
}

struct Profile_SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Profile_SettingsView()
    }
}
