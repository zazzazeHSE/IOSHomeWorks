
//
//  TaskWidget.swift
//  TaskWidget
//
//  Created by Егор on 24.02.2021.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData
import CoreDataFramework

struct Provider: IntentTimelineProvider {
    private let container = CoreDataStack.shared.managedObjectContext
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(task: nil, date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(task: nil, date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let request = Task.createFetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Task.deadlineDate), ascending: true)
        request.sortDescriptors = [sort]
        let tasks = try? container.fetch(request)
        let notCompletedTasks = tasks?.filter{ $0.taskStatus != .completed && $0.deadlineDate ?? Date() > Date()}
        let currentDate = Date()
        if let correctTasks = notCompletedTasks {
            if correctTasks.count == 0 {
                entries.append(SimpleEntry(task: nil, date: Date(), configuration: configuration))
                let timeline = Timeline(entries: entries, policy: .never)
                completion(timeline)
                return
            }
            
            for task in correctTasks {
                let entryDate = Calendar.current.date(byAdding: .hour, value: 20, to: currentDate)!
                let entry = SimpleEntry(task: task, date: task.deadlineDate ?? entryDate, configuration: configuration)
                entries.append(entry)
            }
            
        } else {
            entries.append(SimpleEntry(task: nil, date: Date(), configuration: configuration))
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    var task: Task?
    var date: Date
    let configuration: ConfigurationIntent
}

struct TaskWidgetEntryView : View {
    var entry: SimpleEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let task = entry.task {
                HStack {
                    Text(task.title)
                        .font(.title)
                        .foregroundColor(Color("TitleText"))
                    Spacer()
                    Text(Date(), style: .date)
                        .fontWeight(.light)
                        .font(.caption)
                        .foregroundColor(Color("Text"))
                }
                
                Text(task.text)
                    .font(.body)
                    .foregroundColor(Color("Text"))
                
                HStack(spacing: 10) {
                    Rectangle()
                        .fill(Color(task.getStatusColor()))
                        .frame(width: 20, height: 20)
                        .cornerRadius(10)
                    Text(task.getStatusText())
                        .foregroundColor(Color("Text"))
                }
                
                Spacer()
            } else {
                Text("Нет ближайших активных задач")
                    .font(.title)
                    .foregroundColor(Color("TitleText"))
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 15)
    }
}

@main
struct TaskWidget: Widget {
    let kind: String = "TaskWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            TaskWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])
    }
}

struct TaskWidget_Previews: PreviewProvider {
    static var previews: some View {
        TaskWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
