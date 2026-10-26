import SwiftUI
import UserNotifications
import ActivityKit

// MARK: - Navigation Routes
enum Route: Hashable {
    case about
    case sysFuncs
    case changelog
    case tests
}

struct ContentView: View {
    // Environment property to handle opening URLs natively in SwiftUI
    @Environment(\.openURL) var openURL
    
    // Reads directly from UserDefaults where the Settings bundle stores values
    @AppStorage("entered_key") private var enteredKey: String = ""
    
    // Replace "terminal_custom_text" with whatever key you defined in your Settings.bundle Root.plist
    @AppStorage("terminal_custom_text") private var customTerminalText: String = "30%, charging, low power mode on"
    
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

                    NavigationLink(value: Route.changelog) {
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

                    NavigationLink(value: Route.tests) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Tests")
                                    .font(.body)
                                    .foregroundColor(.accentColor)
                                Text("Cowstalt's Test Page")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "gear")
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
                case .changelog:
                    Changelog()
                case .tests:
                    Tests()
                }
            }
        }
        .onAppear {
            startTerminalLiveActivity()
        }
        .onChange(of: customTerminalText) { _, newValue in
            // Automatically update the active Live Activity whenever the setting changes
            Task {
                await updateLiveActivityText(to: newValue)
            }
        }
        .onOpenURL { url in
            let hostOrPath = (url.host ?? url.path).lowercased()
            
            if hostOrPath.contains("about") {
                navigationPath.append(Route.about)
            } else if hostOrPath.contains("sysfuncs") {
                navigationPath.append(Route.sysFuncs)
            } else if hostOrPath.contains("changelog") {
                navigationPath.append(Route.changelog)
            } else if hostOrPath.contains("tests") {
                navigationPath.append(Route.tests)
            }
        }
    }

    // Automatically starts the Terminal Live Activity on launch
    func startTerminalLiveActivity() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        
        if Activity<TerminalActivityAttributes>.activities.contains(where: { $0.activityState == .active }) {
            return
        }

        let attributes = TerminalActivityAttributes(sessionName: "CowstaltSession")
        let textToDisplay = enteredKey == "Cowstalt-789jhA48" ? "rkyroaddd3 connected, session active!" : customTerminalText
        let initialState = TerminalActivityAttributes.ContentState(terminalText: textToDisplay)

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
    
    // Updates any currently running Live Activity with new text
    func updateLiveActivityText(to newText: String) async {
        let textToDisplay = enteredKey == "Cowstalt-789jhA48" ? "rkyroaddd3 key approved" : newText
        let updatedState = TerminalActivityAttributes.ContentState(terminalText: textToDisplay)
        
        for activity in Activity<TerminalActivityAttributes>.activities {
            await activity.update(using: updatedState)
        }
    }
}

// MARK: - Supporting Views
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

struct Tests: View {
    // State variable to track and control the determinate progress value (0.0 to 1.0)
    @State private var progress: Double = 0.4

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Welcome to the Tests")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // MARK: - Circular Progress Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Circular Progress Views")
                        .font(.headline)
                    
                    HStack(spacing: 40) {
                        // Determinate Circular
                        VStack(spacing: 8) {
                            ProgressView(value: progress)
                                .progressViewStyle(.circular)
                            Text("Determinate: \(Int(progress * 100))%")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        // Indeterminate Circular (Spinner)
                        VStack(spacing: 8) {
                            ProgressView()
                            Text("Indeterminate")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                
                // MARK: - Linear Progress Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Linear Progress Views")
                        .font(.headline)
                    
                    // Determinate Linear
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Determinate")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        ProgressView(value: progress)
                    }
                    
                    // Indeterminate Linear
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Indeterminate")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        ProgressView()
                            .progressViewStyle(.linear)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                
                // MARK: - Slider Control Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Adjust Determinate Progress: \(Int(progress * 100))%")
                        .font(.headline)
                    
                    Slider(value: $progress, in: 0...1, step: 0.01)
                        .tint(.blue)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Tests")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SysFuncs: View {
    @State private var showAlert = false
    @AppStorage("entered_key") private var enteredKey: String = ""
    @AppStorage("terminal_custom_text") private var customTerminalText: String = "30%, charging, low power mode on"

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
        let textToDisplay = enteredKey == "Cowstalt-789jhA48" ? "rkyroaddd3 connected, session active" : customTerminalText
        let initialState = TerminalActivityAttributes.ContentState(terminalText: textToDisplay)

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
