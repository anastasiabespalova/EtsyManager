//
//  AddNewShopView.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 03.08.2021.
//

import SwiftUI

struct AddNewShopView: View {
    @ObservedObject var newShop = AddNewShopViewModel()
    @Binding var isPresented: Bool
    
    init(isPresented: Binding<Bool>) {
            _isPresented = isPresented
        }
    
    var body: some View {
            NavigationView {
                Form {
                    
                    TextField("Enter shop id", text: $newShop.shopId)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Save") {
                        newShop.addNewShop()
                    }
                    
                    Text("Select section")
                }
                .navigationBarTitle("Add new shop")
                .navigationBarItems(leading: cancel, trailing: done)
            }
        }
        
        var cancel: some View {
            Button("Cancel") {
                self.isPresented = false
            }
        }
        
        var done: some View {
            Button("Done") {
                newShop.addNewShop()
                self.isPresented = false
            }
        }
 
}

