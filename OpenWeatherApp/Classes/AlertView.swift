//
//  AlertView.swift
//  OpenWeatherApp
//
//  Created by Snehal Kerkar on 02/06/23.
//

import UIKit

final class AlertView: NSObject {
	
	/// Shows an error alert
	/// - Parameters:
	///   - title: error title
	///   - message: error meassage
	///   - view: parent view on which alert to be shown
	static func showAlert(
		title: String = "ERROR",
		message: String,
		on view: UIViewController
	) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Got it!", style: .default))
		DispatchQueue.main.async {
			view.present(alert, animated: true)
		}
	}
}
