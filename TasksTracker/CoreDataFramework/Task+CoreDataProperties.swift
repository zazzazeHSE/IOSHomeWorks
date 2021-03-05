//
//  Task+CoreDataProperties.swift
//  TasksTracker
//
//  Created by Егор on 22.02.2021.
//
//

import Foundation
import CoreData
import UIKit


extension Task {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }
    @NSManaged public var id: String?
    @NSManaged public var title: String
    @NSManaged public var text: String
    @NSManaged public var deadlineDate: Date?
    @NSManaged public var notificationIdentifier: String?
    @NSManaged public var taskStatus: TaskStatus
    @NSManaged public var synchronizedStatus: SynchronizationStatus
    @NSManaged public var creationTime: Date?
    
    public func getStatusText() -> String {
        switch taskStatus {
        case .active:
            return "В процессе"
        case .waiting:
            return "Ожидает"
        case .completed:
            return "Выполнена"
        default:
            return ""
        }
    }
    
    public func getStatusColor() -> UIColor {
        switch taskStatus {
        case .active:
            return UIColor(red: 0.246, green: 0.517, blue: 0.141, alpha: 1)
        case .waiting:
            return UIColor(red: 0.893, green: 0.576, blue: 0.282, alpha: 1)
        case .completed:
            return UIColor(red: 0.823, green: 0.339, blue: 0.208, alpha: 1)
        default:
            return .clear
        }
    }

}

extension Task : Identifiable {
}

@objc public enum TaskStatus: Int32, Codable{
    case active = 0
    case waiting = 1
    case completed = 2
}

@objc public enum SynchronizationStatus: Int32, Codable {
    case created = 0
    case updated = 1
    case synchronized = 2
}
