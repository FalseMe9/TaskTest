#if os(iOS)
import ActivityKit
import WidgetKit
import SwiftUI

struct TimerActivityView : View {
    let context : ActivityViewContext<TimerAttribute>
    var body: some View{
        HStack{
            VStack{
                Text(context.attributes.timerName)
                    .font(.headline)
                Text(context.state.endTime, style: .timer)
                    .font(.title.bold())
            }
            .padding(.horizontal)
        }
    }
}

struct LiveWidget: Widget {
    let kind: String = "Tutorial_Widget"
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerAttribute.self){context in
            TimerActivityView(context: context)
        } dynamicIsland: {
            context in
            DynamicIsland{
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom")
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T")
            } minimal: {
                Text("M")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}
#endif
