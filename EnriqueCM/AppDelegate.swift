//
//  AppDelegate.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 16/04/15.
//  Copyright (c) 2015 Enrique Choynowski Melgarejo. All rights reserved.
//

import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var shortcutItem: UIApplicationShortcutItem?
    var needToGoToSection: String?
    private var session: WCSession?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        if(WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session?.delegate = self
            session?.activateSession()
        }
        session = WCSession.defaultSession()
        
        var performShortcutDelegate = true
        
        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem {
            
            print("Application launched via shortcut")
            self.shortcutItem = shortcutItem
            
            performShortcutDelegate = false
        }
        
        return performShortcutDelegate
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        print("Application did become active")
        
        guard let shortcut = shortcutItem else { return }
        
        print("- Shortcut property has been set")
        
        handleShortcutItem(shortcut)
        
        self.shortcutItem = nil
    }
    
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        completionHandler(handleShortcutItem(shortcutItem))
    }
    
    private func handleShortcutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {

        var succeeded = true

        switch shortcutItem.type {
        case ShortcutType.ShareAll.rawValue:
            performActionShareAll()
        case ShortcutType.ViewProfile.rawValue:
            performActionShortcut(shortcutItem.localizedTitle)
        case ShortcutType.ViewProjects.rawValue:
            performActionShortcut(shortcutItem.localizedTitle)
        default:
            succeeded = false
        }
        
        return succeeded
    }
    
    private func performActionShareAll() {
        
        if let wd = self.window {
            var vc = wd.rootViewController
            if let viewController = vc as? UINavigationController {
                vc = viewController.visibleViewController
            }
            
            if let currentVC = vc as? PerformShortcutAction {
                currentVC.shareAllInformation()
            }
        }
    }
    
    private func performActionShortcut(shortcutTitle: String?) {
        guard let title = shortcutTitle as String? else { return }
        
        if let wd = self.window {
            var vc = wd.rootViewController
            if let viewController = vc as? UINavigationController {
                vc = viewController.visibleViewController
            }
            
            if let currentVC = vc as? PerformShortcutAction {
                currentVC.viewSectionWithTitle(title)
            }
        }
    }
}

// pragma mark - WatchKit
extension AppDelegate: WCSessionDelegate {
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        print(message)
    }
}

