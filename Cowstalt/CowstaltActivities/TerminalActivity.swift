import ActivityKit
import SwiftUI
import WidgetKit

struct TerminalLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TerminalActivityAttributes.self) { context in
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Circle().fill(Color.red).frame(width: 8, height: 8)
                    Circle().fill(Color.yellow).frame(width: 8, height: 8)
                    Circle().fill(Color.green).frame(width: 8, height: 8)
                    Spacer()
                }
                .padding(.bottom, 2)

                Text("Cowstalt")
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundColor(.gray)

                Text("> \(context.state.terminalText)")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.black)
            .activityBackgroundTint(Color.black)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    Text(context.state.terminalText)
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(.green)
                }
            } compactLeading: {
                Text("$").font(.system(size: 12, design: .monospaced)).foregroundColor(.green)
            } compactTrailing: {
                Image(systemName: "terminal").foregroundColor(.green)
            } minimal: {
                Image(systemName: "terminal").foregroundColor(.green)
            }
        }
    }
}
