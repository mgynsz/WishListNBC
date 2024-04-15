//
//  AppDelegate.swift
//  WishListNBC
//
//  Created by David Jang on 4/9/24.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WishListNBC")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        startApplication()
        return true
    }
    
    private func startApplication() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let mainViewController = ViewController()
        let navigationController = UINavigationController(rootViewController: mainViewController)
        
        // 네비게이션바 전역 설정
        setupNavigationBarAppearance()
        
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        self.window?.backgroundColor = .white
    }
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        // 폰트 및 색상 설정
        let titleFont = UIFont(name: "HelveticaNeue-Bold", size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
        let largeTitleFont = UIFont(name: "HelveticaNeue-Bold", size: 20) ?? UIFont.boldSystemFont(ofSize: 20)
        
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black, .font: titleFont]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black, .font: largeTitleFont]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().prefersLargeTitles = false
    }
}

