//
//  UIManager.swift
//  Potatso
//
//  Created by LEI on 12/27/15.
//  Copyright © 2015 TouchingApp. All rights reserved.
//

import Foundation
import ICSMainFramework
import PotatsoLibrary
import Aspects

class UIManager: NSObject, AppLifeCycleProtocol {
    
    var keyWindow: UIWindow? {
        return UIApplication.shared.keyWindow
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Seven_initRootVcs()
        return true
    }
    
    func Seven_initRootVcs() {
        // true 时运行的是小 7 加速器的界面。 false 时运行的是 Potatso 原来的界面。
//        let fakeVC = false
        let fakeVC = true
        if fakeVC {
            keyWindow?.rootViewController = MainController()
            let imageArray: NSArray = ["launch0", "launch1","launch2"]
            LaunchIntroductionView.shared(withImages: imageArray as! [Any], buttonImage: "button_1_12", buttonFrame: CGRect(x:0, y:UIScreen.main.bounds.size.height - UIScreen.main.bounds.size.width * 0.5, width:UIScreen.main.bounds.size.width, height:UIScreen.main.bounds.size.width * 0.5))
        } else {
            UIView.appearance().tintColor = Color.Brand
            
            UITableView.appearance().backgroundColor = Color.Background
            UITableView.appearance().separatorColor = Color.Separator
            
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().barTintColor = Color.NavigationBackground
            
            UITabBar.appearance().isTranslucent = false
            UITabBar.appearance().backgroundColor = Color.TabBackground
            UITabBar.appearance().tintColor = Color.TabItemSelected
            
            keyWindow?.rootViewController = makeRootViewController()
            
            Receipt.shared.validate()
        }
    }
    
    func makeRootViewController() -> UITabBarController {
        let tabBarVC = UITabBarController()
        tabBarVC.viewControllers = makeChildViewControllers()
        tabBarVC.selectedIndex = 0
        return tabBarVC
    }
    
    func makeChildViewControllers() -> [UIViewController] {
        let cons: [(UIViewController.Type, String, String)] = [(HomeVC.self, "Home".localized(), "Home"), (DashboardVC.self, "Statistics".localized(), "Dashboard"), (CollectionViewController.self, "Manage".localized(), "Config"), (SettingsViewController.self, "More".localized(), "More")]
        return cons.map {
            let vc = UINavigationController(rootViewController: $0.init())
            vc.tabBarItem = UITabBarItem(title: $1, image: $2.originalImage, selectedImage: $2.templateImage)
            return vc
        }
    }
    
}
