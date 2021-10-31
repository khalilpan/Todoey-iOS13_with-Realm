//
//  AppDelegate.swift
//  Destini
//
//  Created by Khalil panahi
//

import CoreData
import RealmSwift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // to get file address of realm database
        print(Realm.Configuration.defaultConfiguration.fileURL)

        do {
            let realm = try Realm()
        } catch {
            print("Error initializing new Realm : ", error)
        }

        return true
    }
}
