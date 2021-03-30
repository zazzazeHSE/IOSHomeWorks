//
//  ViewController.swift
//  IOSEx
//
//  Created by Егор on 30.03.2021.
//

import UIKit

class ViewController: UIViewController {

    private var points = [
        [ Point(x: 0, y: 0),
        Point(x: 0, y: 1),
        Point(x: 0, y: 2) ],
        [ Point(x: 1, y: 0),
        Point(x: 1, y: 1),
        Point(x: 1, y: 2) ],
        [ Point(x: 2, y: 0),
        Point(x: 2, y: 1),
        Point(x: 2, y: 2) ]
    ]
    
    private let collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    private let restartButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collection.delegate = self
        collection.dataSource = self
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.register(Cell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collection)
        
        restartButton.setTitle("Заново", for: .normal)
        restartButton.setTitleColor(.systemBlue, for: .normal)
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        restartButton.addTarget(self, action: #selector(restartButtonTapped), for: .touchUpInside)
        view.addSubview(restartButton)
        NSLayoutConstraint.activate([
            collection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            collection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            collection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            
            restartButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            restartButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        
    }
    
    @objc private func restartButtonTapped() {
        restart()
    }
    
    private func check() -> SelectionStatus {
        for i in 0..<3 {
            if points[i][0].selectionStatus == points[i][1].selectionStatus
                && points[i][1].selectionStatus == points[i][2].selectionStatus
                && points[i][0].selectionStatus != .none {
                return points[i][0].selectionStatus
            }
        }
        for i in 0..<3 {
            if points[0][i].selectionStatus == points[1][i].selectionStatus
                && points[1][i].selectionStatus == points[2][i].selectionStatus
                && points[0][i].selectionStatus != .none {
                return points[0][i].selectionStatus
            }
        }
        
        if points[1][1].selectionStatus == points[0][0].selectionStatus
            && points[1][1].selectionStatus == points[2][2].selectionStatus
            && points[1][1].selectionStatus != .none {
            return points[1][1].selectionStatus
        }
        
        if points[1][1].selectionStatus == points[2][0].selectionStatus
            && points[1][1].selectionStatus == points[0][2].selectionStatus
            && points[1][1].selectionStatus != .none {
            return points[1][1].selectionStatus
        }
        return .none
    }
    
    private func restart() {
        collection.reloadData()
    }
    
    private func twoInRow() -> Int {
        for i in 0..<3 {
            if points[i][0].selectionStatus == points[i][1].selectionStatus
                || points[i][1].selectionStatus == points[i][2].selectionStatus
                || points[i][0].selectionStatus == points[i][2].selectionStatus {
                return i
            }
        }
        return -1
    }
    
    private func twoInColumn() -> Int {
        for i in 0..<3 {
            if points[0][i].selectionStatus == points[1][i].selectionStatus
                || points[1][i].selectionStatus == points[2][i].selectionStatus
                || points[0][i].selectionStatus == points[2][i].selectionStatus {
                return i
            }
        }
        return -1
    }
    
    private func twoInDiag() -> Bool {
        if points[1][1].selectionStatus == points[0][0].selectionStatus
            || points[1][1].selectionStatus == points[2][2].selectionStatus
            || points[1][1].selectionStatus == points[2][2].selectionStatus {
            return true
        }
        return false
    }
    
    private func twoInPobDiag() -> Bool {
        if points[1][1].selectionStatus == points[2][0].selectionStatus
            || points[1][1].selectionStatus == points[0][2].selectionStatus
            || points[1][1].selectionStatus == points[0][2].selectionStatus {
            return true
        }
        return false
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width / 3 - 20 , height: collectionView.frame.height / 3 - 40)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
        points[indexPath.row / 3][indexPath.row % 3].selectionStatus = .none
        cell.currentPoint = points[indexPath.row / 3][indexPath.row % 3]
        cell.image.image = nil
        return cell
    }
    
    
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if points[indexPath.row / 3][indexPath.row % 3].selectionStatus != .none {
            return
        }
        let cell = collectionView.cellForItem(at: indexPath) as! Cell
        cell.image.image = UIImage(systemName: "xmark")
        cell.image.tintColor = .green
        points[indexPath.row / 3][indexPath.row % 3].selectionStatus = .player
        if check() == .player {
            let alert = UIAlertController(title: "Игра завершена", message: "Вы победили", preferredStyle: .alert)
            let action = UIAlertAction(title: "Начать заново", style: .default, handler: { _ in
                self.restart()
            })
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        }
        if check() == .none && points.allSatisfy({ $0.allSatisfy( { $0.selectionStatus != .none }) }) {
            let alert = UIAlertController(title: "Игра завершена", message: "Ничья", preferredStyle: .alert)
            let action = UIAlertAction(title: "Начать заново", style: .default, handler: { _ in
                self.restart()
            })
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        }
        var i = 0
        var j = 0
        repeat {
            i = Int.random(in: 0...2)
            j = Int.random(in: 0...2)
        } while points[i][j].selectionStatus != .none
        let compCell = collectionView.cellForItem(at: IndexPath(row: i * 3 + j, section: 0)) as! Cell
        points[i][j].selectionStatus = .comp
        compCell.image.image = UIImage(systemName: "circle")
        compCell.image.tintColor = .red
        if check() == .comp {
            let alert = UIAlertController(title: "Игра завершена", message: "Вы проиграли", preferredStyle: .alert)
            let action = UIAlertAction(title: "Начать заново", style: .default, handler: { _ in
                self.restart()
            })
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        }
        if check() == .none && points.allSatisfy({ $0.allSatisfy( { $0.selectionStatus != .none }) }) {
            let alert = UIAlertController(title: "Игра завершена", message: "Ничья", preferredStyle: .alert)
            let action = UIAlertAction(title: "Начать заново", style: .default, handler: { _ in
                self.restart()
            })
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        }
    }
}

