//
//  AppDelegate.swift
//  test-push-app
//
//  Created by Keegan Cruickshank on 25/3/17.
//  Copyright © 2017 Keegan Cruickshank. All rights reserved.
//

import UIKit

import Firebase

import UserNotifications

import FirebaseAuth

import FirebaseInstanceID

import FirebaseMessaging

import FirebaseDatabase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, FIRMessagingDelegate {

    var window: UIWindow?
    
    var ref: FIRDatabaseReference!
    
    var userId: String?
    
    var gotNotification: Bool = false

    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        UIApplication.shared.statusBarStyle = .lightContent
        // Override point for customization after application launch.
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            
            FIRApp.configure()
            
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
            let _ = FirebaseManager.current
            
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        
        
        let _ = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            if let userUid = user?.uid {
                self.userId = userUid
                self.ref = FIRDatabase.database().reference()
                if let refreshedToken = FIRInstanceID.instanceID().token() {
                    self.ref.child("advertisement_data/admin_contacts")
                        .observeSingleEvent(of: .value, with: { (snapshot) in
                            if let users = snapshot.value as? NSDictionary {
                                for (path, user) in users {
                                    if let user = user as? NSDictionary, let path = path as? String, let id = user["uid"] as? String {
                                        if id == userUid {
                                            if let data = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] {
                                                if self.gotNotification == false {
                                                    self.gotNotification = true
                                                    self.passNotification(notification: data as! [AnyHashable : Any])
                                                }
                                            }
                                            self.ref.child("advertisement_data/admin_contacts/" + path).updateChildValues(["token" : refreshedToken])
                                        }
                                    }
                                }
                            }
                            
                        }) { (error) in
                            print(error.localizedDescription)
                    }
                }
                
            }
        }
        
        
        return true
    }
    
    func tokenRefreshNotification(_ notification: Notification) {
        if let userUid = self.userId {
            self.ref = FIRDatabase.database().reference()
            if let refreshedToken = FIRInstanceID.instanceID().token() {
                self.ref.child("advertisement_data/admin_contacts")
                    .observeSingleEvent(of: .value, with: { (snapshot) in
                        if let users = snapshot.value as? NSDictionary {
                            for (path, user) in users {
                                if let user = user as? NSDictionary, let path = path as? String, let id = user["uid"] as? String {
                                    if id == userUid {
                                        self.ref.child("advertisement_data/admin_contacts/" + path).updateChildValues(["token" : refreshedToken])
                                    }
                                }
                            }
                        }
                        
                    }) { (error) in
                        print(error.localizedDescription)
                }
            }
        }
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

    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print("Message Recieved: " + remoteMessage.description)
    }
    
    func passNotification(notification: [AnyHashable: Any]) {
        if let type = notification["callFor"] as? String {
            if type == "confirm media" {
                if let adId = notification["adID"] as? String {
                    ref.child("advertisement_data/advertisements").child(adId).observeSingleEvent(of: .value, with: { (snapshot) in
                        if let value = snapshot.value as? NSDictionary, let description = value["advertisement_description"] as? String, let verification_status = value["advertisement_verification_status"] as? NSDictionary, let verified = verification_status["verifying"] as? String, let id = value["advertisement_id"] as? String, let media = value["advertisement_media"] as? String, let media_url = value["advertisement_media_url"] as? String, let name = value["advertisement_name"] as? String, let user_id = value["advertisement_user_id"] as? String {
                            
                            let campaign = Campaign.init(description: description, id: id, media: media, media_url: media_url, name: name, user_id: user_id, verification_status: verified)
                            print("Campaign Made")
                            if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "New Media") as? NewMediaViewController {
                                print("New Media Controller Used")
                                if let window = self.window, let rootViewController = window.rootViewController {
                                    print("Got Current Window")
                                    var currentController = rootViewController
                                    while let presentedController = currentController.presentedViewController {
                                        currentController = presentedController
                                    }
                                    controller.campaign = campaign
                                    print("Gonna Present")
                                    currentController.present(controller, animated: true, completion: nil)
                                }
                            }
                        }
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        passNotification(notification: userInfo)
        
    }


}

