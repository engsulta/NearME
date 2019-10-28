//
//	Location.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Location : Codable {

	let address : String?
	let cc : String?
	let city : String?
	let country : String?
	let distance : Int?
	let formattedAddress : [String]?
	let labeledLatLngs : [LabeledLatLng]?
	let lat : Float?
	let lng : Float?
	let postalCode : String?
	let state : String?


	enum CodingKeys: String, CodingKey {
		case address = "address"
		case cc = "cc"
		case city = "city"
		case country = "country"
		case distance = "distance"
		case formattedAddress = "formattedAddress"
		case labeledLatLngs = "labeledLatLngs"
		case lat = "lat"
		case lng = "lng"
		case postalCode = "postalCode"
		case state = "state"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		address = try values.decodeIfPresent(String.self, forKey: .address)
		cc = try values.decodeIfPresent(String.self, forKey: .cc)
		city = try values.decodeIfPresent(String.self, forKey: .city)
		country = try values.decodeIfPresent(String.self, forKey: .country)
		distance = try values.decodeIfPresent(Int.self, forKey: .distance)
		formattedAddress = try values.decodeIfPresent([String].self, forKey: .formattedAddress)
		labeledLatLngs = try values.decodeIfPresent([LabeledLatLng].self, forKey: .labeledLatLngs)
		lat = try values.decodeIfPresent(Float.self, forKey: .lat)
		lng = try values.decodeIfPresent(Float.self, forKey: .lng)
		postalCode = try values.decodeIfPresent(String.self, forKey: .postalCode)
		state = try values.decodeIfPresent(String.self, forKey: .state)
	}


}