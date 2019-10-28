//
//	VenuePage.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct VenuePage : Codable {

	let id : String?


	enum CodingKeys: String, CodingKey {
		case id = "id"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
	}


}