//
//  CommitCheckerWidget.swift
//  CommitCheckerWidget
//
//  Created by Егор on 15.10.2020.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct CommitCheckerWidgetEntryView : View {
    var entry: LastCommitEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4){
            Text("apple/swift's Latest Commit")
                .font(.system(.title3))
                .foregroundColor(.black)
            Text(entry.commit.message)
                .font(.system(.callout))
                .foregroundColor(.black)
                .bold()
            Text("by \(entry.commit.author) at \(entry.commit.date)")
                .font(.system(.caption))
                .foregroundColor(.black)
            Text("Updated at \(Self.format(date: entry.date))")
        }
        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [.orange, .yellow]), startPoint: .top, endPoint: .bottom))
    }
    static func format(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        return formatter.string(from: date)
    }
}

@main
struct CommitCheckerWidget: Widget {
    let kind: String = "CommitCheckerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CommitTimeline()) { entry in
            CommitCheckerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Swift's Latest Commit")
        .description("Shows the last commit at the swift repo.")
    }
}

