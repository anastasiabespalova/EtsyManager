//
//  ShopInfo.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 03.08.2021.
//

import Foundation

struct ShopInfo: Codable, Hashable, Identifiable, Comparable {
    var id: Int { shop_id ?? 0}
    
    var shop_id: Int?
    var creation_tsz: Float
    var digital_listing_count: Int
    var digital_sale_message: String
    var icon_url_fullxfull: String
    var last_modified_tsz: Float
    var listing_active_count: Int
    var listing_inactive_count: Int
    var listing_sold_count: Int
    var sale_message: String
    var shop_name: String
    var is_listing_sold_count_updated: Bool
    
    static func < (lhs: ShopInfo, rhs: ShopInfo) -> Bool {
        lhs.last_modified_tsz < rhs.last_modified_tsz
    }
    
    init() {
        shop_id = nil
        creation_tsz = 0
        digital_listing_count = 0
        digital_sale_message = ""
        icon_url_fullxfull = ""
        last_modified_tsz = 0
        listing_active_count = 0
        listing_inactive_count = 0
        listing_sold_count = 0
        sale_message = ""
        shop_name = ""
        is_listing_sold_count_updated = false
    }
    
    init(shop: Shop) {
        self.shop_id = Int(shop.shop_id)
        self.creation_tsz = shop.creation_tsz
        self.digital_listing_count = Int(shop.digital_listing_count)
        self.digital_sale_message = shop.digital_sale_message ?? ""
        self.icon_url_fullxfull = shop.icon_url_fullxfull ?? ""
        self.last_modified_tsz = shop.last_modified_tsz
        self.listing_active_count = Int(shop.listing_active_count)
        self.listing_inactive_count = Int(shop.listing_inactive_count)
        self.listing_sold_count = Int(shop.listing_sold_count)
        self.sale_message = shop.sale_message ?? ""
        self.shop_name = shop.shop_name ?? ""
        self.is_listing_sold_count_updated = shop.is_listing_sold_count_updated
    }
    
    
    
}

/*
struct AirportInfo: Codable, Hashable, Identifiable, Comparable {
    fileprivate(set) var icao: String?
    private(set) var latitude: Double
    private(set) var longitude: Double
    private(set) var location: String
    private(set) var name: String
    private(set) var timezone: String
    
    var friendlyName: String {
        Self.friendlyName(name: name, location: location)
    }
    
    static func friendlyName(name: String, location: String) -> String {
        var shortName = name
            .replacingOccurrences(of: " Intl", with: " ")
            .replacingOccurrences(of: " Int'l", with: " ")
            .replacingOccurrences(of: "Intl ", with: " ")
            .replacingOccurrences(of: "Int'l ", with: " ")
        for nameComponent in location.components(separatedBy: ",").map({ $0.trim }) {
            shortName = shortName
                .replacingOccurrences(of: nameComponent+" ", with: " ")
                .replacingOccurrences(of: " "+nameComponent, with: " ")
        }
        shortName = shortName.trim
        shortName = shortName.components(separatedBy: CharacterSet.whitespaces).joined(separator: " ")
        if !shortName.isEmpty {
            return "\(shortName), \(location)"
        } else {
            return location
        }
    }

    var id: String { icao ?? name }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: AirportInfo, rhs: AirportInfo) -> Bool { lhs.id == rhs.id }
    static func < (lhs: AirportInfo, rhs: AirportInfo) -> Bool { lhs.id < rhs.id }
}

// TODO: share code with AirlineInfoRequest
class AirportInfoRequest: FlightAwareRequest<AirportInfo>, Codable {
    private(set) var airport: String?
    
    static var all: [AirportInfo] {
        requests.values.compactMap({ $0.results.value.first }).sorted()
    }
    
    var info: AirportInfo? { results.value.first }

    private static var requests = [String:AirportInfoRequest]()
    private static var cancellables = [AnyCancellable]()
    
    @discardableResult
    static func fetch(_ airport: String, perform: ((AirportInfo) -> Void)? = nil) -> AirportInfo? {
        let request = Self.requests[airport]
        if request == nil {
            Self.requests[airport] = AirportInfoRequest(airport: airport)
            Self.requests[airport]?.fetch()
            return self.fetch(airport, perform: perform)
        } else if perform != nil {
            if let info = request!.info {
                perform!(info)
            } else {
                request!.results.sink { infos in
                    if let info = infos.first {
                        perform!(info)
                    }
                }.store(in: &Self.cancellables)
            }
        }
        return Self.requests[airport]?.results.value.first
    }
    
    private init(airport: String) {
        super.init()
        self.airport = airport
    }
    
    override var query: String {
        var request = "AirportInfo?"
        request.addFlightAwareArgument("airportCode", airport)
        return request
    }
    
    override var cacheKey: String? { "\(type(of: self)).\(airport!)" }

    override func decode(_ data: Data) -> Set<AirportInfo> {
        var result = (try? JSONDecoder().decode(AirportInfoRequest.self, from: data))?.flightAwareResult
        result?.icao = airport
        return Set(result == nil ? [] : [result!])
    }

    private var flightAwareResult: AirportInfo?

    private enum CodingKeys: String, CodingKey {
        case flightAwareResult = "AirportInfoResult"
    }
}
*/
