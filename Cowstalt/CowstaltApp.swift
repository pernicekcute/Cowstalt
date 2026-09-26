import SwiftUI
import UserNotifications

@main
struct CowstaltApp: App {
    init() {
        // Set the delegate when the app launches to handle notifications properly
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
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Tells iOS to display the banner, sound, and badge while active
        completionHandler([.banner, .sound, .badge])
    }
}

struct ContentView: View {
    // Environment property to handle opening URLs natively in SwiftUI
    @Environment(\.openURL) var openURL

    var body: some View {
        NavigationStack {
            List {
                Section {
                    // Navigation link with slide-in animation
                    NavigationLink(destination: DetailView(title: "About")) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("About")
                                .font(.body)
                                .foregroundColor(.primary)
                            Text("About Cowstalt")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    NavigationLink(destination: SysFuncs()) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("System Functions")
                                .font(.body)
                                .foregroundColor(.primary)
                            Text("System Functions for Cowstalt")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section {
                    // Button to jump straight to the app's Settings bundle page
                    Button(action: {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            openURL(settingsURL)
                        }
                    }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Open Cowstalt Settings")
                                    .font(.body)
                                    .foregroundColor(.accentColor)
                                Text("Manage app preferences")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "gear")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Cowstalt")
        }
    }
}

// The destination view that it slides into
struct DetailView: View {
    let title: String
    
    var body: some View {
        VStack {
            Text("Welcome to \(title)")
                .font(.title2)
                .padding()
            Spacer()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SysFuncs: View {
    // State variable to trigger the dialog alert
    @State private var showAlert = false

    var body: some View {
        VStack(spacing: 16) {
            Button("Dialog") {
                // Triggers the dialog alert
                showAlert = true
            }
            .buttonStyle(.glass)
            
            Button("Notification") {
                // Triggers the real system notification
                requestPermissionAndSchedule()
            }
            .buttonStyle(.glass)
        }
        .padding()
        .navigationTitle("Cowstalt System Functions")
        .navigationBarTitleDisplayMode(.inline)
        // Attaches the actual dialog box to the view
        .alert("Cowstalt Alert", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("This is your system dialog in action.")
        }
    }
    
    // Function that handles permission and sends the real notification
    func requestPermissionAndSchedule() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "Cowstalt System"
                content.body = "This is a real notification from your app!"
                content.sound = .default
                
                // Triggers 3 seconds after you tap the button and leave the app
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
}

#Preview {
    ContentView()
}
