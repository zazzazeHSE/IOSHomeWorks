//
//  Cell.swift
//  IOSEx
//
//  Created by Егор on 30.03.2021.
//

import UIKit

class Cell: UICollectionViewCell {
    var currentPoint: Point!
    var image = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        image.translatesAutoresizingMaskIntoConstraints = false
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        addSubview(image)
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
}
