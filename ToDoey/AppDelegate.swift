//
//  AppDelegate.swift
//  ToDoey
//
//  Created by mohamed hashem on 10/28/18.
//  Copyright © 2018 mohamed hashem. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//      print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        return true
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
       notificationCall()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
       
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
     
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
              
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
               
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
    func notificationCall(){
        let content = UNMutableNotificationContent()
        content.title = "ToDoey"
        content.body = "😀 Thank's For Using App"
        
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "TimerDone", content: content, trigger: trigger)
        
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }


}

