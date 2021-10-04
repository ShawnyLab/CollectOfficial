//
//  AppDelegate.swift
//  Collect
//
//  Created by 박진서 on 2021/09/03.
//

import UIKit
import Firebase


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var shouldSupportAllOrientation = true
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        let service = Service.shared
        let _ = CartModel.shared
        service.fetchBrand()
        service.fetchMainBanner()
        let coordinator = SceneCoordinator(window: window!)
        let firstVM = FirstViewModel(title: "first", sceneCoordinator: coordinator)
        let firstScene = Scene.first(firstVM)
        coordinator.transition(to: firstScene, using: .root, animated: true)
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {

        if (shouldSupportAllOrientation == true){
            return UIInterfaceOrientationMask.all
//  모든방향 회전 가능
        }
        return UIInterfaceOrientationMask.landscape

//  가로방향으로 고정.
    }


//    // MARK: UISceneSession Lifecycle
//
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }
//

}

