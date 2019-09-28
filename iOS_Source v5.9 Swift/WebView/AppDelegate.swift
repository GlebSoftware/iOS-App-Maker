//
//  OnlineAppCreator.com
//  WebViewGold for iOS 5.9
//

import UIKit
import UserNotifications
import OneSignal
import GoogleMobileAds

var registerforpush = "true"  //Set to "true" to ask your users for push notications permission in general

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().barStyle = .blackOpaque
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.white

        if registerforpush.isEqual("true")
        {
            let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: true]
            
            OneSignal.initWithLaunchOptions(launchOptions,appId: "YOUR_ONESIGNAL_APP_ID",handleNotificationAction: {(result) in let payload = result?.notification.payload
                if let additionalData = payload?.additionalData {
                let noti_url = additionalData["url"] as! String
                    UserDefaults.standard.set(noti_url, forKey: "Noti_Url")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OpenWithNotificationURL"), object: nil, userInfo: nil)

                }},settings: onesignalInitSettings)
            
            OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        }
        GADMobileAds.configure(withApplicationID: "YOUR_ADMOB_APP_ID")
        
     
        if registerforpush.isEqual("true")
        {
            OneSignal.promptForPushNotifications(userResponse: { accepted in
                print("User accepted notifications: \(accepted)")
            })
            if application.responds(to: #selector(getter: application.isRegisteredForRemoteNotifications))
            {
                if #available(iOS 10.0, *)
                {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) {(accepted, error) in
                        if !accepted {
                            print("Notification access denied")
                        }
                    }
                }
                else
                {
                    application.registerUserNotificationSettings(UIUserNotificationSettings(types: ([.sound, .alert, .badge]), categories: nil))
                    application.registerForRemoteNotifications()
                }
            }
            else
            {
                application.registerForRemoteNotifications(matching: ([.badge, .alert, .sound]))
            }
        }
        
        return true
    }
    func application(_ application: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any] = [:] ) -> Bool {
        
        let sendingAppID = options[.sourceApplication]
        
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
            let _ = components.path,
            let params = components.queryItems else {
                return false
        }
        
        if let url  = params.first(where: { $0.name == "link" })?.value {
            UserDefaults.standard.set(url, forKey: "DeepLinkUrl")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OpenWithExternalLink"), object: nil, userInfo: nil)

            return true
        } else {
            print("URL missing")
            return false
        }
    }
  
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    
}
