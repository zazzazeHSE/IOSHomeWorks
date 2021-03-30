//
//  Point.swift
//  IOSEx
//
//  Created by Егор on 30.03.2021.
//

import Foundation

struct Point {
    let x: Int32
    let y: Int32
    var selectionStatus: SelectionStatus = .none
}

enum SelectionStatus: Int32 {
    case none = 0
    case player = 1
    case comp = 2
}
