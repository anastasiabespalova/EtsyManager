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
    
    var endPos = 0
    if let range = html.range(of: "shop_id") {
        endPos = html.distance(from: html.startIndex, to: range.upperBound)
    }

    var stringShopId = ""
    var ind = endPos + 2
    while ind > 0 {
        if Array(html)[ind] != "," {
            stringShopId += String(Array(html)[ind])
            ind += 1
        } else {
            ind = -1
        }
    }
    print(stringShopId)
   
    return Int(stringShopId)!
}


