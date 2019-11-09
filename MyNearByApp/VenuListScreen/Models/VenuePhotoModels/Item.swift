//
//	Item.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Item : Codable {

	let createdAt : Int?
	let height : Int?
	let id : String?
	let prefix : String?
	let suffix : String?
	let visibility : String?
	let width : Int?


	enum CodingKeys: String, CodingKey {
		case createdAt = "createdAt"
		case height = "height"
		case id = "id"
		case prefix = "prefix"
		case suffix = "suffix"
		case visibility = "visibility"
		case width = "width"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		createdAt = try values.decodeIfPresent(Int.self, forKey: .createdAt)
		height = try values.decodeIfPresent(Int.self, forKey: .height)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		prefix = try values.decodeIfPresent(String.self, forKey: .prefix)
		suffix = try values.decodeIfPresent(String.self, forKey: .suffix)
		visibility = try values.decodeIfPresent(String.self, forKey: .visibility)
		width = try values.decodeIfPresent(Int.self, forKey: .width)
	}


}