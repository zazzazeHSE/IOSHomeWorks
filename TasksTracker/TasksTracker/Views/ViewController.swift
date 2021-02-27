//
//  ViewController.swift
//  TasksTracker
//
//  Created by Егор on 22.02.2021.
//

import UIKit
import CoreData
import WidgetKit
import CoreDataFramework

class ViewController: UIViewController {

    var titleLabel = UILabel(frame: .zero)
    var addTaskButton = UIButton()
    private let cellId = "cellId"
    var collection: UICollectionView!
    var container = CoreDataStack.shared.managedObjectContext
    var tasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        titleLabel.text = "Задачи"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 34)
        titleLabel.textColor = UIColor(named: "TitleText")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TaskCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = UIColor(named: "Background")
        collection.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 10)
        
        addTaskButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        addTaskButton.frame.size = CGSize(width: 50, height: 50)
        addTaskButton.addTarget(self, action: #selector(openTaskViewController), for: .touchUpInside)
        addTaskButton.imageView?.contentMode = .scaleAspectFit
        self.loadSavedData()
        addSubviews()
        initConstraints()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        saveChanges()
    }
    
    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(addTaskButton)
        view.addSubview(collection)
    }
    
    private func configureTitleLabel() {
        titleLabel.text = "Задачи"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 34)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func initConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: view.frame.width / 2),
            
            collection.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            collection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            collection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            
            addTaskButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addTaskButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
    }

    
    private func loadSavedData() {
        let request = Task.createFetchRequest()
        do {
            tasks = try container.fetch(request)
            collection.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
    private func saveChanges() {
        if container.hasChanges {
            do {
                try container.save()
                WidgetCenter.shared.reloadAllTimelines()
            } catch {
                print("Saving error")
            }
        }
    }
    
    private func delete(task: Task) {
        container.delete(task)
    }
    
    @objc private func openTaskViewController() {
        let tasksvc = TaskViewController()
        let newTask = Task(context: container)
        tasksvc.currentTask = newTask
        tasksvc.dismissButton.setTitle("Добавить", for: .normal)
        tasksvc.dismissButton.addAction(UIAction { _ in
            newTask.taskStatus = .waiting
            self.saveCurrent(newTask, title: tasksvc.titleTextField.text!, text: tasksvc.descriptionTextField.text!, date: tasksvc.datePicker.date)
            tasksvc.dismiss(animated: true, completion: nil)
            self.saveChanges()
            self.loadSavedData()
        }, for: .touchUpInside)
        self.present(tasksvc, animated: true, completion: nil)
    }
    
    private func saveCurrent(_ task: Task, title: String, text: String, date: Date) {
        task.title = title
        task.text = text
        task.deadlineDate = date
        task.taskStatus = .waiting
        if task.taskStatus != .completed {
            self.createNotificationRequestFor(task: task)
        }
    }
    
    private func createNotificationRequestFor(task: Task) {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Уведомление о задаче"
        content.body = "Задача \"\(task.title)\" скоро закончится"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "taskIdentifier"
        content.userInfo = ["test" : "test1"]
        
        let triggerDate = Calendar.current.date(byAdding: .hour, value: -1, to: task.deadlineDate ?? Date())!
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let uniqueId = UUID().uuidString
        let request = UNNotificationRequest(identifier: uniqueId, content: content, trigger: trigger)
        
        deleteNotification(with: task.notificationIdentifier)
        
        task.notificationIdentifier = uniqueId
        center.add(request, withCompletionHandler: nil)
    }
    
    private func deleteNotification(with id: String?) {
        let center = UNUserNotificationCenter.current()
        if let deletedId = id {
            center.removePendingNotificationRequests(withIdentifiers: [deletedId])
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 - 20, height: 120)
    }
}

//MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TaskCollectionViewCell
        cell.taskData = tasks[indexPath.row]
        cell.isUserInteractionEnabled = true
        return cell
    }
   
}

//MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTask = tasks[indexPath.row]
        let tasksvc = TaskViewController()
        tasksvc.currentTask = selectedTask
        tasksvc.dismissButton.setTitle("Сохранить", for: .normal)
        tasksvc.dismissButton.addAction(UIAction { _ in
            self.saveCurrent(selectedTask, title: tasksvc.titleTextField.text!, text: tasksvc.descriptionTextField.text!, date: tasksvc.datePicker.date)
            self.saveChanges()
            self.loadSavedData()
            tasksvc.dismiss(animated: true, completion: nil)
        }, for: .touchUpInside)
        self.present(tasksvc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let identifier = "\(indexPath.row)" as NSString
        return UIContextMenuConfiguration(identifier: identifier, previewProvider: .none) { _ in
            let copyAction = UIAction(title: "Copy", image: UIImage(systemName: "doc.on.doc")) { _ in
                let newTask = Task(context: self.container)
                let copiedTask = self.tasks[indexPath.row]
                newTask.title = copiedTask.title
                newTask.text = copiedTask.text
                newTask.taskStatus = copiedTask.taskStatus
                newTask.deadlineDate = copiedTask.deadlineDate
                self.saveChanges()
                self.loadSavedData()
            }
            
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: UIMenuElement.Attributes.destructive) { value in
                self.container.delete(self.tasks[indexPath.row])
                self.saveChanges()
                self.loadSavedData()
            }
            
            return UIMenu(title: "", image: nil, children: [self.makeTaskStatusMenu(for: self.tasks[indexPath.row]), copyAction, deleteAction])
        }
    }
    
    private func makeTaskStatusMenu(for task: Task) -> UIMenu {
        let completedAction = UIAction(title: "Выполнена", identifier: UIAction.Identifier("0"), handler: { _ in
            task.taskStatus = .completed
            self.saveChanges()
            self.loadSavedData()
        })
        
        let waitingAction = UIAction(title: "Ожидает", identifier: UIAction.Identifier("1"), handler: { _ in
            task.taskStatus = .waiting
            self.saveChanges()
            self.loadSavedData()
        })
        
        let activeAction = UIAction(title: "В процессе", identifier: UIAction.Identifier("2"), handler: { _ in
            task.taskStatus = .active
            self.saveChanges()
            self.loadSavedData()
        })
        
        return UIMenu(title: "Изменить статус", image: nil, options: .displayInline, children: [completedAction, waitingAction, activeAction])
    }
}
