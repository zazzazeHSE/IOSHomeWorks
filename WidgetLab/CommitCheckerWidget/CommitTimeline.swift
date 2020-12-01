//
//  CommitTimeline.swift
//  WidgetLab
//
//  Created by Егор on 15.10.2020.
//

import Foundation
import WidgetKit

struct CommitTimeline : TimelineProvider{
    
    typealias Entry = LastCommitEntry
    
    func placeholder(in context: Context) -> LastCommitEntry {
        let fakeCommit = Commit(message: "message", author: "author", date: "date")
        return LastCommitEntry(commit: fakeCommit, date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (LastCommitEntry) -> Void) {
        let fakeCommit = Commit(message: "Add widget", author: "Egor", date: "2020-10-15")
        let entry = LastCommitEntry(commit: fakeCommit, date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<LastCommitEntry>) -> Void) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
        CommitLoader.fetch{ result in
            let commit: Commit
            if case .success(let fetchedCommit) = result{
                commit = fetchedCommit
            }
            else{
                commit = Commit(message: "Failed to  load", author: "", date: "")
                
            }
            let entry = LastCommitEntry(commit: commit, date: currentDate)
            let timeLine = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeLine)
        }
    }
}
