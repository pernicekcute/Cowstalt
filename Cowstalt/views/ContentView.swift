import SwiftUI

struct ContentView: View {
    @State private var message = "Welcome to Cowstalt!"

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "circle.grid.hex")
                .font(.system(size: 50))
                .foregroundColor(.accentColor)
            
            Text("Cowstalt")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
            
            Button("Moo!") {
                message = "The herd says hello!"
            }
            .buttonStyle(.glass)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
