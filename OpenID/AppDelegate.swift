//
//  AppDelegate.swift
//  OpenID
//
//  Created by Hernan Zalazar on 8/1/17.
//  Copyright © 2017 Auth0. All rights reserved.
//

import UIKit
import AppAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = SessionManager.shared.current?.resumeAuthorizationFlow(with: url) ?? false
        SessionManager.shared.current = nil
        return handled
    }
}

