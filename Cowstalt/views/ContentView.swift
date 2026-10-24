import SwiftUI
import UserNotifications
import ActivityKit

// Define routes for programmatic navigation
enum Route: Hashable {
    case about
    case sysFuncs
}

@available(iOS 26.0, *)
struct ContentView: View {
    // Environment property to handle opening URLs natively in SwiftUI
    @Environment(\.openURL) var openURL
    // Reads directly from UserDefaults where the Settings bundle stores values
    @AppStorage("entered_key") private var enteredKey: String = ""
    
    // Navigation path to manage deep linking pushes
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                if enteredKey == "Cowstalt-789jhA48" {
                    Section {
                        Text("Developer Mode Activated.")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                    }
                }

                Section {
                    // Navigation links using value-based routing
                    NavigationLink(value: Route.about) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("About")
                                .font(.body)
                                .foregroundColor(.primary)
                            Text("About Cowstalt")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    NavigationLink(value: Route.sysFuncs) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("System Functions")
                                .font(.body)
                                .foregroundColor(.primary)
                            Text("System Functions for Cowstalt")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }

                    NavigationLink(value: Route.sysFuncs) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Changelog")
                                    .font(.body)
                                    .foregroundColor(.accentColor)
                                Text("Cowstalt's Changelog")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "archivebox")
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
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .about:
                    DetailView(title: "About")
                case .sysFuncs:
                    SysFuncs()
                }
                case .changelog:
                    Changelog()
                }
            }
        }
        .onAppear {
            startTerminalLiveActivity()
        }
        .onOpenURL { url in
            // Parse incoming custom URL scheme (e.g., cowstalt://about or cowstalt://sysfuncs)
            let hostOrPath = (url.host ?? url.path).lowercased()
            
            if hostOrPath.contains("about") {
                navigationPath.append(Route.about)
            } else if hostOrPath.contains("sysfuncs") {
                navigationPath.append(Route.sysFuncs)
            }
        }
    }

    // Automatically starts the Terminal Live Activity on launch
    func startTerminalLiveActivity() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        
        // Prevent launching duplicate active sessions
        if Activity<TerminalActivityAttributes>.activities.contains(where: { $0.activityState == .active }) {
            return
        }

        let attributes = TerminalActivityAttributes(sessionName: "CowstaltSession")
        let initialState = TerminalActivityAttributes.ContentState(
            terminalText: enteredKey == "Cowstalt-789jhA48" ? "rkyroaddd3 connected, session active" : "30%, charging, low power mode on"
        )

        do {
            _ = try Activity.request(
                attributes: attributes,
                content: .init(state: initialState, staleDate: nil),
                pushType: nil
            )
        } catch {
            print("Failed to start Live Activity: \(error.localizedDescription)")
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

struct Changelog: View {
    
    var body: some View {
        VStack {
            Text("Welcome to the Changelog")
                .font(.title2)
                .padding()
            Spacer()
        }
        .navigationTitle("Changelog")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SysFuncs: View {
    // State variable to trigger the dialog alert
    @State private var showAlert = false
    @AppStorage("entered_key") private var enteredKey: String = ""

    var body: some View {
        VStack(spacing: 16) {
            Button("Dialog") {
                showAlert = true
            }
            .buttonStyle(.glass)
            
            Button("Notification") {
                requestPermissionAndSchedule()
            }
            .buttonStyle(.glass)
            
            // Manual trigger button for Live Activity
            Button("Start Live Activity") {
                startTerminalLiveActivity()
            }
            .buttonStyle(.glass)
        }
        .padding()
        .navigationTitle("Cowstalt System Functions")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Cowstalt Alert", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("This is your system dialog in action.")
        }
    }
    
    func startTerminalLiveActivity() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        
        if Activity<TerminalActivityAttributes>.activities.contains(where: { $0.activityState == .active }) {
            return
        }

        let attributes = TerminalActivityAttributes(sessionName: "CowstaltSession")
        let initialState = TerminalActivityAttributes.ContentState(
            terminalText: enteredKey == "Cowstalt-789jhA48" ? "rkyroaddd3 connected, session active" : "30%, charging, low power mode on"
        )

        do {
            _ = try Activity.request(
                attributes: attributes,
                content: .init(state: initialState, staleDate: nil),
                pushType: nil
            )
        } catch {
            print("Failed to start Live Activity: \(error.localizedDescription)")
        }
    }
    
    func requestPermissionAndSchedule() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "Cowstalt"
                content.body = "This is a real notification from your app!"
                content.sound = .default
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
}

#Preview {
    if #available(iOS 26.0, *) {
        ContentView()
    } else {
        Text("Requires iOS 26.0+")
    }
}
