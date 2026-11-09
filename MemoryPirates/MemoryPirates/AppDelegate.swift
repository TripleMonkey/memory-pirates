//
//  AppDelegate.swift
//  MemoryPirates
//
//  Created by Nigel Krajewski on 6/16/23.
//

import UIKit
import CoreData
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // Singleton
    static var sharedContext = AppDelegate().persistentContainer.viewContext
    private override init() { }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Set initial volume value for UserDefaults
        UserDefaults.standard.register(defaults: ["volume" : 1.0])
        configureAudioSession()
        
        return true
    }
    
    // MARK: Audio Session
    
    // Configure the shared audio session for game sound effects and activate it
    // asynchronously so AVAudioPlayer doesn't activate it on the main thread.
    private func configureAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            // Ambient respects the silent switch and mixes with other apps' audio
            try session.setCategory(.ambient, mode: .default)
            if #available(iOS 27.0, *) {
                session.activate { _, error in
                    if let error {
                        print("Audio session activation failed: \(error)")
                    }
                }
            } else {
                // Fall back to synchronous activation on a background queue
                DispatchQueue.global(qos: .userInitiated).async {
                    do {
                        try session.setActive(true)
                    } catch {
                        print("Audio session activation failed: \(error)")
                    }
                }
            }
        } catch {
            print("Audio session configuration failed: \(error)")
        }
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        // Create stroe description for public topscores
        
        let container = NSPersistentCloudKitContainer(name: "MemoryPirates")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

