//
//  SwiftCommitLoader.swift
//  WidgetLab
//
//  Created by Егор on 15.10.2020.
//

import Foundation

struct CommitLoader{
    static func fetch(completion: @escaping (Result<Commit, Error>) -> Void){
        let branchContentsURL = URL(string: "https://api.github.com/repos/apple/swift/branches/main")!
        let task = URLSession.shared.dataTask(with: branchContentsURL){(data, response, error) in
            guard error == nil else{
                completion(.failure(error!))
                return
            }
            let commit = getCommitInfo(from: data!);
            completion(.success(commit))
        }
        task.resume()
    }
    
    static func getCommitInfo(from data: Data) -> Commit{
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        let commitParentJson = json["commit"] as! [String: Any]
        let commitJson = commitParentJson["commit"] as! [String: Any]
        let authorJson = commitJson["author"] as! [String: Any]
        let message = commitJson["message"] as! String
        let author = authorJson["name"] as! String
        let date = authorJson["date"] as! String
        return Commit(message: message, author: author, date: date)
    }
}
