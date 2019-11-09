//
//	Response.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct VenueResponseContainer : Codable {
    
    let venues : [Venue]?
    
    
    enum CodingKeys: String, CodingKey {
        case venues = "venues"
    }
    init(from decoder: Decoder) throws {
        if let values = try? decoder.container(keyedBy: CodingKeys.self){
            venues = try values.decodeIfPresent([Venue].self, forKey: .venues)
        }else {
            let context = DecodingError.Context.init(codingPath: decoder.codingPath, debugDescription: "Unable to decode coordinates!")
            throw DecodingError.dataCorrupted(context)
        }
    }
    
    
}
