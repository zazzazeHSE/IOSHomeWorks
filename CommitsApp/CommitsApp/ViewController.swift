//
//  ViewController.swift
//  CommitsApp
//
//  Created by Егор on 28.11.2020.
//

import UIKit
import CoreData
import SwiftyJSON

class ViewController: UITableViewController {

    var container: NSPersistentContainer!
    var commits = [Commit]()
    var commitPredicate: NSPredicate?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(changeFilter))
        container = NSPersistentContainer(name: "CommitsApp")
        container.loadPersistentStores{ (storeDescription, error) in
            self.container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            if let error = error{
                print("Unresolved error: \(error)")
            }
        }
        performSelector(inBackground: #selector(fetchCommits), with: nil)
        loadSavedData()
    }
    
    func saveContext(){
        if container.viewContext.hasChanges{
            do{
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
    
    @objc func fetchCommits(){
        if let data = try? Data(contentsOf: URL(string: "https://api.github.com/repos/apple/swift/commits?per_page=100")!){
            let json = try! JSON(data: data)
            let jsonCommitArray = json.arrayValue
            print("Received \(jsonCommitArray.count) new commits.")
            DispatchQueue.main.async { [unowned self] in
                for jsonCommit in jsonCommitArray{
                    let commit = Commit(context: self.container.viewContext)
                    self.configure(commit, usingJson: jsonCommit)
                }
                self.saveContext()
                self.loadSavedData()
            }
        }
    }
    
    func configure(_ commit: Commit, usingJson json: JSON){
        var commitAuthor: Author!
        let authorRequest = Author.createFetchRequest()
        authorRequest.predicate = NSPredicate(format: "name == %@", json["commit"]["commiter"]["name"].stringValue)
        if let authors = try? container.viewContext.fetch(authorRequest){
            if authors.count > 0{
                commitAuthor = authors[0]
            }
        }
        if commitAuthor == nil{
            let author = Author(context: container.viewContext)
            author.name = json["commit"]["committer"]["name"].stringValue
            author.email = json["commit"]["committer"]["email"].stringValue
            commitAuthor = author
        }
        commit.sha = json["sha"].stringValue
        commit.message = json["commit"]["message"].stringValue
        commit.url = json["commit"]["url"].stringValue
        commit.author = commitAuthor
        let formatter = ISO8601DateFormatter()
        commit.date = formatter.date(from: json["commit"]["commiter"]["date"].stringValue) ?? Date()
    }
    
    func loadSavedData(){
        let request = Commit.createFetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        request.predicate = commitPredicate
        do{
            commits = try container.viewContext.fetch(request)
            print("Got \(commits.count) commits")
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
    @objc func changeFilter(){
        let ac = UIAlertController(title: "Filter commits...", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Show only fixes", style: .default){ [unowned self] _ in
            self.commitPredicate = NSPredicate(format: "message CONTAINS[c] 'fix'")
            self.loadSavedData()
        })
        ac.addAction(UIAlertAction(title: "Ignore pull requests", style: .default) { [unowned self] _ in
            self.commitPredicate = NSPredicate(format: "NOT message BEGINSWITH 'Merge pull request'")
            self.loadSavedData()
        })
        ac.addAction(UIAlertAction(title: "Show only recent", style: .default){ [unowned self] _ in
            let twelveHoursAgo = Date().addingTimeInterval(-43200)
            self.commitPredicate = NSPredicate(format: "date > %@", twelveHoursAgo as NSDate)
            self.loadSavedData()
        })
        ac.addAction(UIAlertAction(title: "Show all commits", style: .default){ [unowned self] _ in
            self.commitPredicate = nil
            self.loadSavedData()
        })
        ac.addAction(UIAlertAction(title: "Show only Durian commits", style: .default){ [unowned self] _ in
            self.commitPredicate = NSPredicate(format: "author.name == 'Joe Groff'")
            self.loadSavedData()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int{
        return commits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Commit", for: indexPath)
        let commit = commits[indexPath.row]
        cell.textLabel!.text = commit.message
        cell.detailTextLabel!.text = "By \(commit.author.name) on \(commit.date.description)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController{
            vc.detailItem = commits[indexPath.row]
            show(vc, sender: nil)
        }
    }
}

