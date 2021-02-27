//
//  TaskCollectionViewCell.swift
//  TasksTracker
//
//  Created by Егор on 24.02.2021.
//

import UIKit
import CoreDataFramework

class TaskCollectionViewCell: UICollectionViewCell {
    
    var title: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor(named: "TitleText")
        return label
    }()
    
    var text: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "Text")
        return label
    }()
    
    var statusImage: UIImageView = {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 15, height: 15))
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.gray.cgColor)
            ctx.cgContext.setLineWidth(1)
            
            let rectangle = CGRect(x: 0.5, y: 0.5, width: 13, height: 13)
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        let imageView = UIImageView(image: img)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var statusText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor(named: "Text")
        return label
    }()
    
    var deadlineDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .gray
        return label
    }()
    
    var taskData: Task? {
        didSet {
            title.text = taskData?.title
            text.text = taskData?.text
            statusImage.image = statusImage.image?.withRenderingMode(.alwaysTemplate)
            statusImage.tintColor = taskData?.getStatusColor()
            statusText.text = taskData?.getStatusText()
            let formater = DateFormatter()
            formater.dateFormat = "dd.MM.yyyy"
            if let date = taskData?.deadlineDate {
                deadlineDateLabel.text = formater.string(from: date)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor(named: "CellBackground")
        
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        contentView.layer.masksToBounds = true
        
        contentView.layer.shadowColor = UIColor(named: "Shadow")?.cgColor
        contentView.layer.shadowOffset = CGSize(width: 2, height: 2)
        contentView.layer.shadowRadius = 1.5
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.masksToBounds = true
        contentView.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        
        contentView.addSubview(statusImage)
        contentView.addSubview(statusText)
        contentView.addSubview(deadlineDateLabel)
        contentView.addSubview(title)
        contentView.addSubview(text)
        
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            title.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 7),
            
            text.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            text.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 7),
            text.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -7),
            
            statusImage.bottomAnchor.constraint(equalTo:    contentView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            statusImage.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 7),
            
            statusText.centerYAnchor.constraint(equalTo: statusImage.centerYAnchor),
            statusText.leadingAnchor.constraint(equalTo: statusImage.trailingAnchor, constant: 5),
            statusText.trailingAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -7),
            
            deadlineDateLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -7),
            deadlineDateLabel.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            deadlineDateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: title.trailingAnchor, constant: 5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("error")
    }
}
