//
//  AppDelegate.swift
//  WordMatch
//
//  Created by Mookyung Kwak on 2017-01-09.
//  Copyright © 2017 Mookyung Kwak. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // Log in existing user with username and password
        let username = "pporri@gmail.com"  // <--- Update this
        let password = "morris"  // <--- Update this
        
        SyncUser.logIn(with: .usernamePassword(username: username, password: password, register: false), server: URL(string: "http://192.168.1.66:9080")!) { user, error in
            guard let user = user else {
                fatalError(String(describing: error))
            }
            
            // Open Realm
            let configuration = Realm.Configuration(
                syncConfiguration: SyncConfiguration(user: user, realmURL: URL(string: "realm://192.168.1.66:9080/~/wordmatch")!),
                schemaVersion: 3,
                migrationBlock: {
                    migration, oldSchemaVersion in
                    print("migration : \(migration) oldSchemaVersion : \(oldSchemaVersion)")
                    // 버전 2로 올라오면서 Word의 content를 primary key로 변경
                    // ?? 버전 3은 렘 서버 싱크 올리려고 하니까 에러나서 올려봄
                    if (oldSchemaVersion < 3) {
                        migration.enumerateObjects(ofType: Player.className(), { (oldObject, newObject) in
                            let player = Player()
                            let propertNames = oldObject?.objectSchema.properties.map { $0.name }
                            let values = oldObject?.dictionaryWithValues(forKeys: propertNames!)
                            player.setValuesForKeys(values!)
                        })
                        migration.enumerateObjects(ofType: Word.className(), { (oldObject, newObject) in
                            let word = Word()
                            let propertNames = oldObject?.objectSchema.properties.map { $0.name }
                            let values = oldObject?.dictionaryWithValues(forKeys: propertNames!)
                            word.setValuesForKeys(values!)
                        })
                    }
            })
            Realm.Configuration.defaultConfiguration = configuration
            let _ = try! Realm()
        }
        
        return true
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

