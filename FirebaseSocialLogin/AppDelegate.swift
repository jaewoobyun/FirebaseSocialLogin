//
//  AppDelegate.swift
//  FirebaseSocialLogin
//
//  Created by 변재우 on 20190830//.
//  Copyright © 2019 변재우. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase
import GoogleSignIn
import KakaoOpenSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
	
	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
		if let error = error {
			print("failed to sign in with Google account:", error)
			return
		}
		
		guard let idToken = user.authentication.idToken else { return }
		guard let accessToken = user.authentication.accessToken else { return }
		let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
		
		Auth.auth().signIn(with: credential) { (result, error) in
			if let error = error {
				print("Failed to create a Firebase User with Google account: ", error)
			}
			
			print("Successfully logged into Firebase with Google Email: ", result?.user.email, "displayName: ", result?.user.displayName )
		}
	}
	
	func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
		//perform any operations when the user disconnects from app here.
	}
	
	private func setupSessionChangeNotification() {
		NotificationCenter.default.addObserver(forName: NSNotification.Name.KOSessionDidChange, object: nil, queue: .main) { [unowned self](noti) in
			guard let session = noti.object as? KOSession else {return}
			session.isOpen() ? print("Kakao Login") : print("Kakao Logout")
			//setupRootViewController()
		}
	}
	
	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		FirebaseApp.configure()
		
		GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
		GIDSignIn.sharedInstance()?.delegate = self
		
		ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
		
		return true
	}
	
	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
		
		//Facebook?
		let handled = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
		
		//Google?
		GIDSignIn.sharedInstance()?.handle(url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
		
		//Kakao?
		if KOSession.handleOpen(url) {
			return true
		}
		
		
		
		return handled
//		return GoogleHandled
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}

