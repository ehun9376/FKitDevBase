//
//  AppDelegate.swift
//  TestDevBase
//
//  Created by 陳逸煌 on 2025/2/7.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController =  UINavigationController(rootViewController: HomeViewController(viewModel: HomeViewModelImpl())) 
        window?.makeKeyAndVisible()
        return true
    }




}

