//
//  ListingImageURLs.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 13.08.2021.
//

import CoreData
import Foundation

extension ListingImageURLs {
    
    var forListing: Listing {
            get { forListing_!} // TODO: protect against nil before shipping?
            set { forListing_ = newValue }
        }
    
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<ListingImageURLs> {
            let request = NSFetchRequest<ListingImageURLs>(entityName: "ListingImageURLs")
            request.sortDescriptors = [NSSortDescriptor(key: "rank", ascending: true)]
            request.predicate = predicate
            return request
    }
    
    static func withId(_ id: Int, listingImageURLsInfo: ListingImageURLsInfo,  context: NSManagedObjectContext) -> ListingImageURLs {
            // look up icao in Core Data
        let request = fetchRequest(NSPredicate(format: "listing_image_id = %@", NSNumber(value: id)))
        
        let listingImages = (try? context.fetch(request)) ?? []
        
        if let listingImage = listingImages.first {
                // if found, return it
           // print("exists")
                return listingImage
        } else {
            //print("update")
                let listingImage = ListingImageURLs(context: context)
                listingImage.listing_image_id = Int64(id)
                self.update(image: listingImageURLsInfo, context: context)
                return listingImage
        }
    }
    
    static func update(image: ListingImageURLsInfo, context: NSManagedObjectContext)  {
        
        let listingImageURLs = ListingImageURLs(context:context)
        listingImageURLs.rank = Int16(image.rank)
        listingImageURLs.listing_id = Int64(image.listing_id)
        listingImageURLs.url_570xN = image.url_570xN
        listingImageURLs.listing_image_id = Int64(image.listing_image_id)

        listingImageURLs.objectWillChange.send()
        try? context.save()
  
    }
    
}


struct ListingImageURLsInfo: Codable, Hashable, Comparable {
    static func == (lhs: ListingImageURLsInfo, rhs: ListingImageURLsInfo) -> Bool {
        lhs.listing_image_id == rhs.listing_image_id
    }
    
    static func < (lhs: ListingImageURLsInfo, rhs: ListingImageURLsInfo) -> Bool {
        lhs.rank < rhs.rank
    }
    
    var rank: Int
    var listing_id: Int
    var url_570xN: String
    var listing_image_id: Int
    
    init() {
        rank = 0
        listing_id = 0
        url_570xN = ""
        listing_image_id = 0
    }
    
    init(listingImageURLs: ListingImageURLs) {
        self.rank = Int(listingImageURLs.rank)
        self.listing_id = Int(listingImageURLs.listing_id)
        self.url_570xN = listingImageURLs.url_570xN!
        self.listing_image_id = Int(listingImageURLs.listing_image_id)
    }

    

    
    
}
