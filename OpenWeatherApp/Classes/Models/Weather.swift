//
//  Weather.swift
//  OpenWeatherApp
//
//  Created by Snehal Kerkar on 02/06/23.
//

import Foundation

struct Weather: Decodable {
	let id: Int
	let main: String
	let description: String
	let icon: String
}
