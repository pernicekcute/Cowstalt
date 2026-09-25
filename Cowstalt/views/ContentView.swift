import SwiftUI

struct ContentView: View {

    var body: some View {
        NavigationStack {
            List {
                Section {
                    // Row 1: Title + Subtitle + Right Label
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Fake iOS Version")
                                .font(.body)
                                .foregroundColor(.primary)
                            Text("iOS 26")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text("rkyroaddd3")
                            .foregroundColor(.secondary)
                    }
                    
                    // Row 2: Action Style Row
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("checkra1n Boot Screen")
                                .font(.body)
                                .foregroundColor(.primary)
                            Text("To Exit click the boot logo.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text("rkyroaddd3")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Cowstalt Settings")
        }
    }
}

#Preview {
    ContentView()
}
