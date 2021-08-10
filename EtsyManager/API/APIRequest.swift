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
import CoreData

class EtsyAPI {
    
    static var shared = EtsyAPI()
    
  
    let limit = 100

    func getShopInfo(for shopId: Int, completionHandler: @escaping (_ inner: () throws -> ShopInfo?) -> ()) {
        let requestString = "https://openapi.etsy.com/v2/shops/\(shopId)"
        AF.request(requestString + apiKey).validate().responseJSON { response in
            switch response.result {
            case .success:
                let json = JSON(response.data!)
                completionHandler({
                    var shopInfo = ShopInfo()
                    if json["count"].int != nil, json["count"].int! == 1 {
                        //shopInfo.shop_id = json["results"][0]["id"].intValue
                        shopInfo.shop_id = shopId
                        shopInfo.creation_tsz = json["results"][0]["creation_tsz"].floatValue
                        shopInfo.digital_listing_count = json["results"][0]["digital_listing_count"].intValue
                        shopInfo.digital_sale_message = json["results"][0]["digital_sale_message"].stringValue
                        shopInfo.icon_url_fullxfull = json["results"][0]["icon_url_fullxfull"].stringValue
                        shopInfo.last_modified_tsz = json["results"][0]["last_modified_tsz"].floatValue
                        shopInfo.listing_active_count = json["results"][0]["listing_active_count"].intValue
                       // shopInfo.listing_inactive_count = json["results"][0]["listing_inactive_count"].intValue
                        shopInfo.listing_inactive_count = 0
                       // shopInfo.listing_sold_count = json["results"][0]["listing_sold_count"].intValue
                        shopInfo.listing_sold_count = 0
                        shopInfo.sale_message = json["results"][0]["sale_message"].stringValue
                        shopInfo.shop_name = json["results"][0]["shop_name"].stringValue
                        print("success! shopName: \(shopInfo.shop_name)")
                    }
                    return shopInfo
                    
                })
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler({ throw error })
            }
        }
        print("success3!")
        
    }
    
    
    func getAllActiveListings(for shopId: Int, offset: Int, completionHandler: @escaping (_ inner: () throws -> [ListingInfo]?) -> ()) {
        let queue = DispatchQueue(label: "com.test.api", qos: .default)
        let requestString = "https://openapi.etsy.com/v2/shops/\(shopId)/listings/active"
        AF.request(requestString + apiKey + "&limit=\(limit)" + "&offset=\(offset)").validate().responseJSON(queue: queue) { response in
            switch response.result {
            case .success:
                
                let json = JSON(response.data!)
                completionHandler({
                    var listingInfoArray: [ListingInfo] = []
                    if json["count"].int != nil {
                        let numberOfActiveListings = (json["count"].int != nil) ? json["count"].int! : 0
                        let numOfListingsInRequest = (numberOfActiveListings > (self.limit + offset)) ? self.limit : (numberOfActiveListings - offset)
                        for index in 0..<numOfListingsInRequest {
                            // TODO: actually write down parsing
                            var listingInfo = ListingInfo()
                            listingInfo.creation_tsz = json["results"][index]["creation_tsz"].floatValue
                            listingInfo.is_digital = json["results"][index]["is_digital"].boolValue
                            listingInfo.is_private = json["results"][index]["is_private"].boolValue
                            listingInfo.item_dimensions_unit = json["results"][index]["is_private"].stringValue
                            listingInfo.item_height = json["results"][index]["item_height"].intValue
                            listingInfo.item_width = json["results"][index]["item_width"].intValue
                            listingInfo.last_modified_tsz = json["results"][index]["last_modified_tsz"].floatValue
                            listingInfo.listing_description = json["results"][index]["description"].stringValue
                            listingInfo.listing_id = json["results"][index]["listing_id"].intValue
                            listingInfo.num_favorers = json["results"][index]["num_favorers"].intValue
                            listingInfo.price = json["results"][index]["price"].stringValue
                            listingInfo.quantity = json["results"][index]["quantity"].intValue
                            listingInfo.state = json["results"][index]["state"].stringValue
                            
                            //listingInfo.tags = json["results"][index]["tags"][0].stringValue
                            var res = ""
                            for tag in json["results"][index]["tags"] {
                                res = res + tag.1.stringValue + "; "
                            }
                            listingInfo.tags = res
                            
                            listingInfo.title = json["results"][index]["title"].stringValue
                            listingInfo.views = json["results"][index]["views"].intValue
                            listingInfoArray.append(listingInfo)
                        }
                    }
                    return listingInfoArray
                    
                })
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler({ throw error })
            }
        }
    }
    
    
    func getListingInfo(for listingId: Int, completionHandler: @escaping (_ inner: () throws -> ListingInfo?) -> ()) {
        let requestString = "https://openapi.etsy.com/v2/listings/\(listingId)"
        AF.request(requestString + apiKey).validate().responseJSON { response in
            switch response.result {
            case .success:
                let json = JSON(response.data!)
                completionHandler({
                    var listingInfo = ListingInfo()
                    if json["count"].int != nil, json["count"].int! == 1 {
                        
                        listingInfo.creation_tsz = json["results"][0]["creation_tsz"].floatValue
                        listingInfo.is_digital = json["results"][0]["is_digital"].boolValue
                        listingInfo.is_private = json["results"][0]["is_private"].boolValue
                        listingInfo.item_dimensions_unit = json["results"][0]["is_private"].stringValue
                        listingInfo.item_height = json["results"][0]["item_height"].intValue
                        listingInfo.item_width = json["results"][0]["item_width"].intValue
                        listingInfo.last_modified_tsz = json["results"][0]["last_modified_tsz"].floatValue
                        listingInfo.listing_description = json["results"][0]["listing_description"].stringValue
                        listingInfo.listing_id = listingId
                        listingInfo.num_favorers = json["results"][0]["num_favorers"].intValue
                        listingInfo.price = json["results"][0]["price"].stringValue
                        listingInfo.quantity = json["results"][0]["quantity"].intValue
                        listingInfo.state = json["results"][0]["state"].stringValue
                        listingInfo.tags = json["results"][0]["tags"].stringValue
                        listingInfo.title = json["results"][0]["title"].stringValue
                        listingInfo.views = json["results"][0]["views"].intValue

                    }
                    return listingInfo
                    
                })
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler({ throw error })
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
