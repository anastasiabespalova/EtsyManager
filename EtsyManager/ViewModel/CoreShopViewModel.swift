//
//  CoreShopViewModel.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 03.08.2021.
//

import Foundation
import CoreData

class CoreShopViewModel: ObservableObject {
    
    var title: String = ""
    @Published var shops: [Shop] = []
    
    func getAllShops() {
        shops = ShopDataManager.shared.getAllShops()
    }
    
    init() {
        getAllShops()
        ShopDataManager.shared.loadAllShops()
    }

    
   /* func delete(_ task: TaskViewModel) {
        
        let existingTask = CoreDataManager.shared.getTaskById(id: task.id)
        if let existingTask = existingTask {
            CoreDataManager.shared.deleteTask(task: existingTask)
        }
    }
    
    func save() {
        
        let task = Task(context: CoreDataManager.shared.viewContext)
        task.title = title
        
        CoreDataManager.shared.save()
    }
    */
}

/*
struct TaskViewModel {
    
    let task: Task
    
    var id: NSManagedObjectID {
        return task.objectID
    }
    
    var title: String {
        return task.title ?? ""
    }
    
}*/

