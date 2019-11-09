//
//	Photo.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Photo : Codable {

	let count : Int?
	let dupesRemoved : Int?
	let items : [Item]?


	enum CodingKeys: String, CodingKey {
		case count = "count"
		case dupesRemoved = "dupesRemoved"
		case items = "items"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		count = try values.decodeIfPresent(Int.self, forKey: .count)
		dupesRemoved = try values.decodeIfPresent(Int.self, forKey: .dupesRemoved)
		items = try values.decodeIfPresent([Item].self, forKey: .items)
	}


}