//
//  AlertExtensions.swift
//  FirebaseSocialLogin
//
//  Created by 변재우 on 20190907//.
//  Copyright © 2019 변재우. All rights reserved.
//

import UIKit

extension UIAlertController {
	
	static func showMessage(_ message: String) {
		showAlert(title: "", messae: message, actions: [UIAlertAction(title: "OK", style: .cancel, handler: nil)])
		
	}
	
	static func showAlert(title: String?, messae: String?, actions: [UIAlertAction]) {
		DispatchQueue.main.async {
			let alert = UIAlertController(title: title, message: messae, preferredStyle: .alert)
			for action in actions {
				alert.addAction(action)
			}
			if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController, let presenting = navigationController.topViewController {
				presenting.present(alert, animated: true, completion: nil)
			}
		}
	}
	
}
