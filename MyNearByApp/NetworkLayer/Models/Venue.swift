//
//	Venue.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Venue : Codable {

	let categories : [Category]?
	let hasPerk : Bool?
	let id : String?
	let location : Location?
	let name : String?
	let referralId : String?
	let venuePage : VenuePage?


	enum CodingKeys: String, CodingKey {
		case categories = "categories"
		case hasPerk = "hasPerk"
		case id = "id"
		case location
		case name = "name"
		case referralId = "referralId"
		case venuePage
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		categories = try values.decodeIfPresent([Category].self, forKey: .categories)
		hasPerk = try values.decodeIfPresent(Bool.self, forKey: .hasPerk)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		location = try Location(from: decoder)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		referralId = try values.decodeIfPresent(String.self, forKey: .referralId)
		venuePage = try VenuePage(from: decoder)
	}


}