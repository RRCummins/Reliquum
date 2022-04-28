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
        SimpleEntry(date: Date(), event: Event.example, configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), event: Event.example, configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let userDefaults = UserDefaults.shared
        do {
            let event = try userDefaults.getObject(forKey: "1Event", castTo: Event.self)
            let currentDate = Date()
            for hourOffset in 0 ..< 5 {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry = SimpleEntry(date: entryDate, event: event, configuration: configuration)
                entries.append(entry)
            }
        } catch {
            let event = Event.example
            let currentDate = Date()
            for hourOffset in 0 ..< 5 {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry = SimpleEntry(date: entryDate, event: event, configuration: configuration)
                entries.append(entry)
            }
            print(error.localizedDescription)
        }
        //        let userDefaults = UserDefaults(suiteName: "group.widgetcacheplace")
        //        if let event = userDefaults?.value(forKey: "1Event") as? Event {
        //            let currentDate = Date()
        //            for hourOffset in 0 ..< 5 {
        //                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
        //                let entry = SimpleEntry(date: entryDate, event: event, configuration: configuration)
        //                entries.append(entry)
        //            }
        //
        //        } else {
        //            let event = Event.example
        //            let currentDate = Date()
        //            for hourOffset in 0 ..< 5 {
        //                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
        //                let entry = SimpleEntry(date: entryDate, event: event, configuration: configuration)
        //                entries.append(entry)
        //            }
        //
        //        }
        
        //        let currentDate = Date()
        //        for hourOffset in 0 ..< 5 {
        //            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
        //            let entry = SimpleEntry(date: entryDate, event: event, configuration: configuration)
        //            entries.append(entry)
        //        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let event: Event
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
            Text("\(daysUntil) until \(entry.event.name)")
                .foregroundColor(.white)
                .font(.title)
        }
    }
    
    var daysUntil: String {
        let components = Calendar.current.dateComponents([.day, .hour], from: entry.date)
        if let days = components.day, let hours = components.hour {
            if days < 2 {
                return "\(days) Days, \(hours) Hours"
            } else {
                return "\(days) Days"
            }
        }
        
        return "\(components.day ?? 0) Days, \(components.hour ?? 0) Hours"
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
        ReliquumWidgetsEntryView(entry: SimpleEntry(date: Date(), event: Event.example, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
