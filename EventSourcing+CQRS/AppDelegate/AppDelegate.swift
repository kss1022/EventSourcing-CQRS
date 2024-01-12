//
//  AppDelegate.swift
//  Routine
//
//  Created by 한현규 on 2024/01/11.
//

import UIKit
import CoreData
import Firebase
import CocoaLumberjack

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //setupFirebase()
        setupLogger()
        setupNotification()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EventStream")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

}



// MARK: Firebase
extension AppDelegate{
    private func setupFirebase(){
        FirebaseApp.configure()
    }
}

// MARK: Logger
extension AppDelegate{
    
    
    private func setupLogger() {
        let consoleLogger = DDOSLogger.sharedInstance   // console logger
        consoleLogger.logFormatter = RoutineLogFormatter()

        let fileLogger: DDFileLogger = DDFileLogger()   // File Logger
        fileLogger.logFormatter = RoutineLogFormatter()
        fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
        fileLogger.maximumFileSize = 1 * 1024 * 1024
        fileLogger.logFileManager.maximumNumberOfLogFiles = 4
        
        let crashlyticsLogger = DDCrashlyticsLogger()   //Crashtics Logger
        crashlyticsLogger.logFormatter = RoutineLogFormatter()
        
        DDLog.add(consoleLogger)
        DDLog.add(fileLogger)
        DDLog.add(crashlyticsLogger)
                
        //#if DEBUG
        //        let consoleLogger = DDOSLogger.sharedInstance
        //        consoleLogger.logFormatter = RoutineLogFormatter()
        //        DDLog.add(consoleLogger)            // console logger
        //#else
        //        let fileLogger: DDFileLogger = DDFileLogger()   // File Logger
        //        fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
        //        fileLogger.maximumFileSize = 1 * 1024 * 1024
        //        fileLogger.logFileManager.maximumNumberOfLogFiles = 4
        //
        //        let crashlyticsLogger = DDCrashlyticsLogger()   //Crashtics Logger
        //
        //        DDLog.add(fileLogger)
        //        DDLog.add(crashlyticsLogger)
        //
        //#endif
    }

}


extension AppDelegate{
    func setupNotification(){
        UNUserNotificationCenter.current().delegate = self
    }
}


// MARK: CoreData
extension AppDelegate{
    //Core Data Saving support
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
}


// MARK: LocalNotification
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {        
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner, .sound, .badge])
    }
}
