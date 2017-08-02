//
//  ViewController.swift
//  OpenID
//
//  Created by Hernan Zalazar on 8/1/17.
//  Copyright © 2017 Auth0. All rights reserved.
//

import UIKit
import AppAuth

class ViewController: UIViewController {

    let auth0 = Auth0Configuration(clientId: "Y1ZS5uig4KrgQ8JLWYNXuylkcTazmkUE", domain: "overmind.auth0.com", redirectUri: "com.auth0.openid.sample.openid://appauth")

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func start(_ sender: Any) {
        let baseUrl = URL(string: "https://\(auth0.domain)")!

        let authorize = URL(string: "/authorize", relativeTo: baseUrl)?.absoluteURL
        let token = URL(string: "/oauth/token", relativeTo: baseUrl)?.absoluteURL
        let configuration = OIDServiceConfiguration(authorizationEndpoint: authorize!, tokenEndpoint: token!)

        let additionalParameters = ["audience": "https://overmind.auth0.com/api/v2/"]
        let request = OIDAuthorizationRequest(configuration: configuration, clientId: auth0.clientId, scopes: [OIDScopeOpenID, OIDScopeProfile], redirectURL: URL(string: auth0.redirectUri)!, responseType: OIDResponseTypeCode, additionalParameters: additionalParameters)
        let session = OIDAuthState.authState(byPresenting: request, presenting: self) { [weak self] (state, error) in
            if let error = error {
                let alert = UIAlertController(title: "Failed to auth", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
                return
            }
            guard let state = state else {
                let alert = UIAlertController(title: "Failed to auth", message: "No Auth State", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
                return
            }

            let alert = UIAlertController(title: "Auth Completed", message: "Obtained \(state.lastTokenResponse?.idToken ?? "<NO ID_TOKEN>")", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }
        SessionManager.shared.current = session
    }
}

class SessionManager {
    static let shared = SessionManager()
    var current: OIDAuthorizationFlowSession? = nil
}


struct Auth0Configuration {
    let clientId: String
    let domain: String
    let redirectUri: String
}

