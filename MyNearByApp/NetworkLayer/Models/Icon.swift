//
//	Icon.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Icon : Codable {

	let prefix : String?
	let suffix : String?


	enum CodingKeys: String, CodingKey {
		case prefix = "prefix"
		case suffix = "suffix"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		prefix = try values.decodeIfPresent(String.self, forKey: .prefix)
		suffix = try values.decodeIfPresent(String.self, forKey: .suffix)
	}


}