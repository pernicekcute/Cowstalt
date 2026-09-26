import SwiftUI

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
    var body: some View {
        VStack {
            Button("Dialog") {
                // Action
            }
            .buttonStyle(.glass)
            
            Button("Notification") {
                // Action
            }
            .buttonStyle(.glassProminent)
            .tint(.blue)
            Spacer()
        }
        .navigationTitle("Cowstalt System Functions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ContentView()
}
