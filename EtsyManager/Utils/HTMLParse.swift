//
//  HTMLParse.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 03.08.2021.
//

import Foundation

import SwiftSoup

func getNumberOfSales(for shopName: String) -> Int {

    let url = URL(string:"https://www.etsy.com/shop/\(shopName)")!
    let html = try! String(contentsOf: url)
    let document = try! SwiftSoup.parse(html)
    var numberOfSales: Int
    
    if let numberOfSalesInString = try! document.getElementsByClass("wt-text-caption wt-no-wrap").first()?.text() {
        numberOfSales = Int(numberOfSalesInString.split(separator: " ")[0])!
        print(numberOfSales)
        return numberOfSales
    }
   
    return 0

}

func getShopId(for shopName: String) -> Int {
    let url = URL(string:"https://www.etsy.com/shop/\(shopName)")!
    let html = try! String(contentsOf: url)
    let document = try! SwiftSoup.parse(html)
    var _: Int
    
    let elements = try! document.select("shop_id")
    print(elements.get(0) )
  /*  if let numberOfSalesInString =  document.getElementsByClass("Etsy.Context.data.shop_id").first()?.text() {
       // numberOfSales = Int(numberOfSalesInString.split(separator: " ")[0])!
        print(numberOfSales)
        return numberOfSales
    return 1
    }*/
   
    return 0
}
