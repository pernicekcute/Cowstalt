import SwiftUI

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
