//
//  AppDelegate.swift
//  4RealThisTime2
//
//  Created by Milksteaks on 10/24/22.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import UserNotifications
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("User granted permission for notifications.")
            } else {
                print("User did not grant permission for notifications.")
            }
        }
        
      
        
        let notificationTitles = ["Panda Taxi", "Penguin Taxi", "Fox Taxi"]
       
        let messages = ["Remember, it's okay to take breaks. They help you recharge and refocus.",
                        "Need to focus? Our pomodoro timer app can help you get in the zone",
                        "Hope your having a great day!",
                        "Feeling overwhelmed? Lets go for drive!",
                        "use our fuckign app....pls "]
        
        let randomMessage = messages.randomElement()!
        
      
  
     
     

                var notificationRequests = [UNNotificationRequest]()
                
                for title in notificationTitles {
                 
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.body = randomMessage
                    content.sound = UNNotificationSound.default
                   
                    if let appLogoURL = Bundle.main.url(forResource: "applogo", withExtension: "png") {
                                  do {
                                      let attachment = try UNNotificationAttachment(identifier: "applogo", url: appLogoURL, options: nil)
                                      content.attachments = [attachment]
                                  } catch {
                                      print("Failed to add app logo as notification icon.")
                                  }
                              }
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    
                    notificationRequests.append(request)
                }
                
                // Schedule a random notification at 9:00 AM
                let randomIndex = Int.random(in: 0..<notificationRequests.count)
                let randomRequest = notificationRequests[randomIndex]
                
                var dateComponents = DateComponents()
                dateComponents.hour = 19
                dateComponents.minute = 50
        
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                
                UNUserNotificationCenter.current().add(randomRequest, withCompletionHandler: nil)
                
        return true
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
    
   


}

