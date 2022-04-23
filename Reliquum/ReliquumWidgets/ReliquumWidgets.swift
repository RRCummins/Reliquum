//
//  ReliquumWidgets.swift
//  ReliquumWidgets
//
//  Created by Ryan Cummins on 4/22/22.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct ReliquumWidgetsEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            ZStack {
                LinearGradient(colors: [.indigo, .clear], startPoint: .bottom, endPoint: .topTrailing)
                LinearGradient(colors: [.pink, .clear], startPoint: .top, endPoint: .bottomLeading)
                LinearGradient(colors: [.indigo, .clear], startPoint: .topLeading, endPoint: .top)
            }
            Text(entry.date, style: .time)
                .foregroundColor(.white)
                .font(.title)
        }
    }
}

@main
struct ReliquumWidgets: Widget {
    let kind: String = "ReliquumWidgets"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ReliquumWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct ReliquumWidgets_Previews: PreviewProvider {
    static var previews: some View {
        ReliquumWidgetsEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
