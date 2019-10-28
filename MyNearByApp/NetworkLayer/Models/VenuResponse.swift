//
//	APIResponse.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct VenuResponse : Codable {

	let meta : Meta?
	let response : Response?


	enum CodingKeys: String, CodingKey {
		case meta
		case response
	}
	init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            meta = try container.decode(Meta.self, forKey: .meta)
            response = try container.decode(Response.self, forKey: .response)
        } else {
            let context = DecodingError.Context.init(codingPath: decoder.codingPath, debugDescription: "Unable to decode coordinates!")
            throw DecodingError.dataCorrupted(context)
        }
	}


}
