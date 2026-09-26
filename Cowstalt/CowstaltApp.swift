import SwiftUI
import UserNotifications

@main
struct CowstaltApp: App {
init() {
        // Set the delegate when the app launches
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
// This class handles showing notifications even while the app is open
class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationDelegate()
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Tells iOS to display the banner, sound, and badge while active
        completionHandler([.banner, .sound, .badge])
    }
}
