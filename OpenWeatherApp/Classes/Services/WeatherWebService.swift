import UIKit

/// This is the web service class to handle open weather api requuests.
final class WeatherWebService: NSObject {
	typealias WeatherServiceResult = Result<Weather, Error>

	// MARK: - Constants
	
	private enum Constants {
		static let apiKey = (Bundle.main.infoDictionary?["API_KEY"] as? String) ?? "" 
		static let keyWeather = "weather"
	}
	
	// MARK: - Methods
	
	/// Fetch `Weather` data
	/// - Parameters:
	///   - city: city of which `Weather` data to be fetched
	///   - completion: returns `Weather` if success, `Error` otherwise
	static func fetchWeatherData(
		of city: String,
		completion: @escaping (WeatherServiceResult) -> Void
	) {
		let link = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(Constants.apiKey)"
		guard let url = URL(string: link) else {
			let error = NSError(domain: "user", code: -1, userInfo: ["description": "Invalid URL"])
			completion(.failure(error))
			return
		}
		print("URL: \(url)")
		let request = URLRequest(url: url)
		URLSession.shared.dataTask(with: request) { data, response, error in
			if let error = error {
				completion(.failure(error))
			} else if let httpResponse = response as? HTTPURLResponse,
					  httpResponse.statusCode != 200
			{
			  print(httpResponse.statusCode)
			  let error = NSError(domain: "user", code: httpResponse.statusCode, userInfo: ["description": "HTTPS response error."])
			  completion(.failure(error))
			} else if let responseData = data {
				print(responseData)
				parseJSON(data: responseData, completion: completion)
			}
		}.resume()
	}
	
	/// Downoad the image from open weather site
	/// - Parameters:
	///   - name: name of the image to be downloaded
	///   - completion: returns `Image` on success
	static func downloadWeatherIcon(name: String, completion: @escaping ((UIImage) -> Void)) {
		let link = "https://openweathermap.org/img/wn/\(name)@2x.png"
		guard let imageURL = URL(string: link) else {
			print("Failed to generate url for image \(link)")
			return
		}
		print("Image \(imageURL) downloading started.")
		URLSession.shared.dataTask(with: imageURL) { data, _, error in
			guard error == nil, let data = data, let image = UIImage(data: data) else {
				print("Failed to download image: error: \(String(describing: error))")
				return
			}
			completion(image)
		}.resume()
	}
}

extension WeatherWebService {
	
	/// Parse the JSON dictionary woth the weather api response
	/// - Parameters:
	///   - data: JSON data to be parsed
	///   - completion: returns `Weather` if success, `Error` otherwise
	static func parseJSON(data: Data, completion: @escaping (WeatherServiceResult) -> Void) {
		do {
			if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
				print(json)
				if let weatherList = json[Constants.keyWeather] as? [[String: Any]],
				   let weatherJSON = weatherList.first
				{
				  let weatherData = try JSONSerialization.data(withJSONObject: weatherJSON)
				  let weather = try JSONDecoder().decode(Weather.self, from: weatherData)
				  print(weather)
				  completion(.success(weather))
				} else {
					let error = NSError(
						domain: "user", code: -1, userInfo: ["description": "weather node is not available"])
					completion(.failure(error))
				}
			} else {
				let error = NSError(
					domain: "user", code: -1, userInfo: ["description": "JSON parsing failed"])
				completion(.failure(error))
			}
		} catch {
			print("Failed to load: \(error.localizedDescription)")
			completion(.failure(error))
		}
	}
}
