//
//  FirestoreTasksRepository.swift
//  TasksTracker
//
//  Created by Егор on 02.03.2021.
//

import Foundation
import FirebaseFirestore
import Firebase
import CoreDataFramework
import FirebaseAuth

class FirestoreTasksRepository: ObservableObject {
    var tasks = [FirebaseTask]()
    var userId: String?
    var db: Firestore
    
    init() {
        db = Firestore.firestore()
        userId = Auth.auth().currentUser?.uid
    }
    
    func loadData(completion: @escaping ([FirebaseTask]?) -> Void) {
        if let userId = userId {
            db.collection("tasks").whereField("userId", isEqualTo: userId).order(by: "createdTime").addSnapshotListener({ querySnapshot, error in
                if let error = error {
                    completion(nil)
                    print(error)
                    return
                }
                if let querySnapshot = querySnapshot {
                    completion(querySnapshot.documents.compactMap { document -> FirebaseTask? in
                        try? document.data(as: FirebaseTask.self)
                    })
                }
            })
        }
    }
    
    func addTask(_ task: Task, completion: @escaping (Bool, FirebaseTask?) -> Void) {
        var firebaseTask = FirebaseTask(task: task)
        guard let userId = userId else {
            return
        }
        do {
            firebaseTask.userId = userId
            let _ = try db.collection("tasks").addDocument(from: firebaseTask)
            completion(true, firebaseTask)
        } catch {
            completion(false, nil)
        }
    }
    
    func updateTask(_ task: Task, completion: @escaping (Bool) -> Void) {
        var firebaseTask = FirebaseTask(task: task)
        guard let taskId = firebaseTask.id else {
            return
        }
        firebaseTask.userId = userId
        do {
            try db.collection("tasks").document(taskId).setData(from: firebaseTask)
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    func removeTask(_ task: Task, completion: @escaping (Bool) -> Void) {
        if let taskId = task.id {
            db.collection("tasks").document(taskId).delete { error in
                completion(error == nil)
            }
        }
    }
}
