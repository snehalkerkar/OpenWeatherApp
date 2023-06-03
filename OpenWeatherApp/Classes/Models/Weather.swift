import Foundation

/// Structure contains all the weather realted required info.
struct Weather: Decodable {
	let id: Int
	let main: String
	let description: String
	let icon: String
}
