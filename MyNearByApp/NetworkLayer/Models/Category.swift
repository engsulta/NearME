//
//	Category.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Category : Codable {

	let icon : Icon?
	let id : String?
	let name : String?
	let pluralName : String?
	let primary : Bool?
	let shortName : String?


	enum CodingKeys: String, CodingKey {
		case icon
		case id = "id"
		case name = "name"
		case pluralName = "pluralName"
		case primary = "primary"
		case shortName = "shortName"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		icon = try values.decodeIfPresent(Icon.self, forKey: .icon)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		pluralName = try values.decodeIfPresent(String.self, forKey: .pluralName)
		primary = try values.decodeIfPresent(Bool.self, forKey: .primary)
		shortName = try values.decodeIfPresent(String.self, forKey: .shortName)
	}


}
