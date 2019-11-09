//
//	Response.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Response : Codable {

	let photos : Photo?


	enum CodingKeys: String, CodingKey {
		case photos
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        photos = try values.decode(Photo.self, forKey: .photos)
	}


}
