//
//  AddNewShopView.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 03.08.2021.
//

import SwiftUI

struct AddNewShopView: View {
    @ObservedObject var newShop = AddNewShopViewModel()
    // @Binding var isPresented: Bool
    @Environment(\.presentationMode) var presentationMode
    @Binding var updateActiveListingsFor: [Int]
    /*
     init(isPresented: Binding<Bool>) {
     _isPresented = isPresented
     
     }*/
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                HStack {
                    Text("Add new shop")
                        .fontWeight(.heavy)
                        .font(.title)
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                    .font(.caption)
                    .foregroundColor(.black)
                }
                Divider()
                Spacer()
            }//Intro VStack close
            .frame(maxWidth: .infinity, maxHeight: 100, alignment: .top)
            
            VStack {
                TextField("Enter shop name", text: $newShop.shopName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Save") {
                    if newShop.addNewShop() {
                        updateActiveListingsFor.append(newShop.shopId)
                    }
                }
                Spacer()
                Image("SavingNewShopImage")
                    .resizable()
                    .frame(width: 300, height: 300)
                Spacer()
            }
            
            .padding([.leading, .trailing], 20)
            Spacer()
            
           /* VStack {
                
                    //.frame(width: 50, height: 50, alignment: .bottom)
            }*/
        }.background(BottomView(presentation: presentationMode) {
            Button {
                presentationMode.wrappedValue.dismiss()
                if newShop.addNewShop() {
                    updateActiveListingsFor.append(newShop.shopId)
                }
            } label: {
                Text("Add new shop")
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





/*
    var body: some View {
        VStack {
            NavigationView {
                Form {
                    
                    TextField("Enter shop name", text: $newShop.shopName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Save") {
                        if newShop.addNewShop() {
                            updateActiveListingsFor.append(newShop.shopId)
                        }
                    }
                    
                    Text("Select section")
                }
                .navigationBarTitle("Add new shop")
                .navigationBarItems(leading: cancel, trailing: done)
               
            }
        Image("SavingNewShopImage")
        }
            
        }
        
        var cancel: some View {
            Button("Cancel") {
                self.isPresented = false
            }
        }
        
        var done: some View {
            Button("Done") {
                if newShop.addNewShop() {
                    updateActiveListingsFor.append(newShop.shopId)
                }
                self.isPresented = false
            }
        }
 
}

*/
