//
//  ViewController.swift
//  FirebaseSocialLogin
//
//  Created by 변재우 on 20190830//.
//  Copyright © 2019 변재우. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import KakaoOpenSDK

import AuthenticationServices


class ViewController: UIViewController, LoginButtonDelegate, GIDSignInUIDelegate {
	

	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupFacebookButtons()
		
		setupGoogleButtons()
		
		setupKakaoButtons()
		
		setupAppleButtons()
		
	}
	
	fileprivate func setupAppleButtons() {
		if #available(iOS 13.0, *) {
			let appleButton = ASAuthorizationAppleIDButton()
			appleButton.frame = CGRect(x: 16, y: 446, width: view.frame.width - 32, height: 50)
			appleButton.addTarget(self, action: #selector(appleIDButtonTapped), for: UIControl.Event.touchUpInside)
			
			
		} else {
			// Fallback on earlier versions
		}
				
	}
	
	@objc func appleIDButtonTapped() {
		if #available(iOS 13.0, *) {
			let request = ASAuthorizationAppleIDProvider().createRequest()
			request.requestedScopes = [.fullName, .email]
			
			let controller = ASAuthorizationController(authorizationRequests: [request])
			controller.delegate = self
			controller.presentationContextProvider = self
			controller.performRequests()
		} else {
			// Fallback on earlier versions
		}
		
	}
	
	fileprivate func setupKakaoButtons() {
		//kakao sign in button
		let kakaoButton = KOLoginButton()
		kakaoButton.frame = CGRect(x: 16, y: 116 + 66 + 66 + 66, width: view.frame.width - 32, height: 50)
		kakaoButton.addTarget(self, action: #selector(kakaoLogin), for: UIControl.Event.touchUpInside)
		view.addSubview(kakaoButton)
		
		let customKakaoButton = UIButton()
		customKakaoButton.frame = CGRect(x: 16, y: 116 + 66 + 66 + 66 + 66, width: view.frame.width - 32, height: 50)
		customKakaoButton.backgroundColor = .yellow
		customKakaoButton.setTitle("Custom Kakao Login Button", for: UIControl.State.normal)
		customKakaoButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
		customKakaoButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		customKakaoButton.addTarget(self, action: #selector(handleCustomKakaoLogin), for: UIControl.Event.touchUpInside)
		view.addSubview(customKakaoButton)
		
		
	}
	
	fileprivate	func setupGoogleButtons() {
		//google sign in button
		let googleButton = GIDSignInButton()
		googleButton.frame = CGRect(x: 16, y: 116 + 66, width: view.frame.width - 32, height: 50)
		view.addSubview(googleButton)
		
		let customGoogleButton = UIButton()
		customGoogleButton.frame = CGRect(x: 16, y: 116 + 66 + 66, width: view.frame.width - 32, height: 50)
		customGoogleButton.backgroundColor = .orange
		customGoogleButton.setTitle("Custom Google Login Button", for: UIControl.State.normal)
		customGoogleButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
		customGoogleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		customGoogleButton.addTarget(self, action: #selector(handleCustomGoogleLogin), for: UIControl.Event.touchUpInside)
		view.addSubview(customGoogleButton)
		
		GIDSignIn.sharedInstance()?.uiDelegate = self

	}
	
	@objc func handleCustomGoogleLogin() {
		GIDSignIn.sharedInstance()?.signIn()
	}
	
	fileprivate func setupFacebookButtons() {
		let loginButton = FBLoginButton()
		
		view.addSubview(loginButton)
		loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
		
		loginButton.delegate = self
		loginButton.permissions = ["email", "public_profile"]
		
		//custom fb login button
		let customFBButton = UIButton()
		customFBButton.backgroundColor = .blue
		customFBButton.frame = CGRect(x: 16, y: 116, width: view.frame.width - 32, height: 50)
		customFBButton.setTitle("Custom FB Login Button", for: UIControl.State.normal)
		customFBButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
		self.view.addSubview(customFBButton)
		
		customFBButton.addTarget(self, action: #selector(handleCustomFBLogin), for: UIControl.Event.touchUpInside)
	}

	
	@objc func handleCustomFBLogin() {
		LoginManager().logIn(permissions: ["email", "public_profile"], from: self) { (result, error) in
			if error != nil {
				print("FB login failed", error)
				return
			}
			//this is the token!!!!!!!!!!
//			print(result?.token?.tokenString)
			self.showEmailAddress()
		}
	}
	
//	@objc func handleKakaoLogin() {
//		print("handle Kakao Login")
//		guard let session = KOSession.shared() else { return }
//
//		if session.isOpen() {
//			session.close()
//		}
//
//		session.open { (error) -> Void in
//			if !session.isOpen() {
//				if let error = error as NSError? {
//					switch error.code {
//					case Int(KOErrorCancelled.rawValue):
//						break
//					default:
//						UIAlertController.showMessage(error.description)
//					}
//				}
//			}
//		}
//	}
	
	//--------------------
	@objc func kakaoLogin(/*_ sender: Any*/) {
		//이전 카카오톡 세션 열려있으면 닫기
		guard let session = KOSession.shared() else {
			return
		}
		if session.isOpen() {
			session.close()
		}
		session.open(completionHandler: { (error) -> Void in
			if error == nil {
				if session.isOpen() {
					//accessToken
					print(session.token?.accessToken)
				} else {
					print("Login failed")
				}
			} else {
				print("Login error : \(String(describing: error))")
			}
			if !session.isOpen() {
				if let error = error as NSError? {
					switch error.code {
					case Int(KOErrorCancelled.rawValue):
						break
					default:
						//간편 로그인 취소
						print("error : \(error.description)")
					}
				}
			}
		})
	}
	
	//--------------
	
	
	@objc func handleCustomKakaoLogin() {
		print("handle Custom Kakao Login")
		kakaoLogin()
	}
	
	func showEmailAddress() {
		
		let fbAccessToken = AccessToken.current
		guard let fbAccessTokenString = fbAccessToken?.tokenString else { return }
		
		let credentials = FacebookAuthProvider.credential(withAccessToken: fbAccessTokenString)
		Auth.auth().signIn(with: credentials) { (result, error) in
			if error != nil {
				print("Something went wrong with our FB user: ", error)
				return
			}
			//user is signed in
			print("Successfully logged in. Email: ", result?.user.email, "DisplayName:", result?.user.displayName)
		}
		
		GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, error) in
			if error != nil{
				print("Failed to start graph request:", error as Any)
			}
			
			print(result as Any)
		}
	}
	
	func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
		print("Did log out of FaceBook")
	}
	
	func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
		if error != nil {
			print(error as Any)
			return
		}
		print("Successfully logged in with facebook")
		showEmailAddress()
		
	}
	


}


extension ViewController: ASAuthorizationControllerDelegate {
	func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
		if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
			if let email = credential.email {
				print(email)
			}
			
//			let userID = credential.user
			
		}
	}
}

extension ViewController: ASAuthorizationControllerPresentationContextProviding {
	func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
		return self.view.window!
	}
	
	
}
