//
//  FirebaseTask.swift
//  TasksTracker
//
//  Created by Егор on 02.03.2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreDataFramework

struct FirebaseTask: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var text: String
    var deadlineDate: Date
    var taskStatus: TaskStatus
    var userId: String?
    var localCreationTime: Date
    @ServerTimestamp var createdTime: Timestamp?
    
    init(task: Task) {
        id = task.id ?? UUID().uuidString
        title = task.title
        text = task.text
        deadlineDate = task.deadlineDate ?? Date()
        taskStatus = task.taskStatus
        localCreationTime = task.creationTime ?? Date()
    }
}

