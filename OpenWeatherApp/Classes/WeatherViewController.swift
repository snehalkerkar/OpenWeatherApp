//
//  WeatherViewController.swift
//  OpenWeatherApp
//
//  Created by Snehal Kerkar on 02/06/23.
//

import CoreLocation
import UIKit

final class WeatherViewController: UIViewController {
	// MARK: - IB Outlets
	
	@IBOutlet private weak var citySearchBar: UISearchBar!
	@IBOutlet private weak var weatherDataStack: UIStackView!
	@IBOutlet private weak var cityLabel: UILabel!
	@IBOutlet private weak var weatherLabel: UILabel!
	@IBOutlet private weak var weatherConditionLabel: UILabel!
	@IBOutlet private weak var weatherIconImageView: UIImageView!
	
	// MARK: - Properties
	
	private let locationManager = CLLocationManager()
	
	// MARK: - View Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()

		locationManager.requestAlwaysAuthorization()
		locationManager.requestWhenInUseAuthorization()
		DispatchQueue.global().async {
			if CLLocationManager.locationServicesEnabled() {
				self.locationManager.delegate = self
				self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
				self.locationManager.startUpdatingLocation()
			}
		}
	}
	
	// MARK: - Private Methods
	
	private func refreshUI(with weather: Weather) {
		cityLabel.text = citySearchBar.text
		weatherLabel.text = weather.main
		weatherConditionLabel.text = weather.description
		WeatherWebService.downloadWeatherIcon(name: weather.icon) { image in
			DispatchQueue.main.async {
				self.weatherIconImageView.image = image
			}
		}
		weatherDataStack.isHidden = false
	}

	private func checkWeather(of city: String) {
		WeatherWebService.fetchWeatherData(of: city) { result in
			switch result {
			case .success(let weather):
				DispatchQueue.main.async {
					self.refreshUI(with: weather)
				}
			case .failure(let error):
				AlertView.showAlert(message: error.localizedDescription, on: self)
			}
		}
	}
}

// MARK: - UISearchBarDelegate

extension WeatherViewController: UISearchBarDelegate {
	func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
		searchBar.resignFirstResponder()
		return true
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let cityName = searchBar.text else {
			// Handle error
			return
		}
		checkWeather(of: cityName)
	}
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location: CLLocation = manager.location else { return }
		CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
			guard error == nil else {
				return
			}
			guard let cityName = placemarks?.first?.locality else {
				
				return
			}
			self.citySearchBar.text = cityName
			let urlEncodedName = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
			self.checkWeather(of: urlEncodedName ?? "")
		}
	}
}
