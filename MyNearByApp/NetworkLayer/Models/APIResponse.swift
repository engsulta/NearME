//
//	APIResponse.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct APIResponse : Codable {

	let meta : Meta?
	let response : Response?


	enum CodingKeys: String, CodingKey {
		case meta
		case response
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		meta = try Meta(from: decoder)
		response = try Response(from: decoder)
	}


}