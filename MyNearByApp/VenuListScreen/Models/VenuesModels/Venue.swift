//
//	Venue.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Venue : Codable {

	let id : String?
	let location : Location!
	let name : String?


	enum CodingKeys: String, CodingKey {
		case id = "id"
		case location = "location"
		case name = "name"
	}
	init(from decoder: Decoder) throws {
        if let values = try? decoder.container(keyedBy: CodingKeys.self){
		id = try values.decodeIfPresent(String.self, forKey: .id)
		location = try values.decodeIfPresent(Location.self, forKey: .location)
		name = try values.decodeIfPresent(String.self, forKey: .name)
        }else {
            let context = DecodingError.Context.init(codingPath: decoder.codingPath, debugDescription: "Unable to decode coordinates!")
            throw DecodingError.dataCorrupted(context)
        }
	}


}
