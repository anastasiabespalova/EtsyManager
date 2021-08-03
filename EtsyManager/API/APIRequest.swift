//
//  APIRequest.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 02.08.2021.
//


import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

class EtsyAPI {
    
    static var shared = EtsyAPI()
    
    
    
    func getAllActiveListings(for shopId: Int) {
        let requestString = "https://openapi.etsy.com/v2/shops/\(shopId)/listings/active"
        AF.request(requestString + apiKey).validate().responseJSON {response in
            switch response.result {
            case .success:
                let json = JSON(response.data!)
                let numberOfActiveListings = (json["count"].int != nil) ? json["count"].int! : 0
                for index in 0..<numberOfActiveListings {
                    // TODO: actually write down parsing
                    print("success! listingId: \(json["results"][index]["listing_id"])")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getShopInfo(for shopId: Int) {
        let requestString = "https://openapi.etsy.com/v2/shops/\(shopId)"
        AF.request(requestString + apiKey).validate().responseJSON {response in
            switch response.result {
            case .success:
                let json = JSON(response.data!)
                if json["count"].int != nil, json["count"].int! == 1 {
                    // TODO: actually write down parsing
                    print("success! shopName: \(json["results"][0]["shop_id"])")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getListingInfo(for listingId: Int) {
        let requestString = "https://openapi.etsy.com/v2/listings/\(listingId)"
        AF.request(requestString + apiKey).validate().responseJSON {response in
            switch response.result {
            case .success:
                let json = JSON(response.data!)
                if json["count"].int != nil, json["count"].int! == 1 {
                    // TODO: actually write down parsing
                    print("success! shopName: \(json["results"][0]["state"])")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
 /*   private let categoriesRequestURL = "https://openapi.etsy.com/v2/taxonomy/categories"
    private let productsSearchRequestURL = "https://openapi.etsy.com/v2/listings/active"
    private let listingImagesRequestURL = "https://openapi.etsy.com/v2/listings/"
    

    private let example = "https://openapi.etsy.com/v3/application/listings/997071949"
    private let example2 = "https://openapi.etsy.com/v2/users/etsystore"
    
    // получить информацию о листинге
    private let example3 = "https://openapi.etsy.com/v2/listings/1036651293/"
    
    // получить все активные листинги магазина
    private let example4 = "https://openapi.etsy.com/v2/shops/27991754/listings/active"
    
    private let example5 = "https://openapi.etsy.com/v2/shops/27991754"
    */
    // 27991754
    /*   func getCategories(giveData: @escaping ([(String,String)]) -> () ) -> Void {
        
        AF.request(categoriesRequestURL + apiKey).validate().responseJSON { response in
            
            switch response.result {
            case .success:
                var categories = [(String,String)]()
                let json = JSON(response.result.value!)
                let categoriesJSON = json["results"]
                for categorie in categoriesJSON {
                    categories.append((categorie.1["category_name"].string!, categorie.1["long_name"].string!) )
                }
                giveData(categories)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    */
 /*   func exampleRequest() {
        AF.request(example5 + apiKey).validate().responseJSON {response in
            
            switch response.result {
            case .success:
              //  let json = JSON(response.result.value!)
                let json = JSON(response.data!)
                let viewsJSON = json["results"][0]["shop_id"]
                print("success! views: \(viewsJSON)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }*/
    
   
}
