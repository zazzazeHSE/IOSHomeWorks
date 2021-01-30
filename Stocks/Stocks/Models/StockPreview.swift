//
//  StockPreview.swift
//  Stocks
//
//  Created by Егор on 30.01.2021.
//

import Foundation

struct StockPreview {
    var name: String
    var symbol: String
}

//MARK: - Decodable
extension StockPreview: Decodable {
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case symbol = "symbol"
    }
}
