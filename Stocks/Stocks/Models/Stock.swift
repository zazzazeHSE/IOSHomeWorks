//
//  Stock.swift
//  Stocks
//
//  Created by Егор on 30.01.2021.
//

import Foundation

struct Stock {
    var symbol: String
    var companyName: String
    var latestPrice: Double
    var change: Double
}

//MARK: - Decodable
extension Stock: Decodable {
    enum CodingKeys: String, CodingKey {
        case symbol = "symbol"
        case companyName = "companyName"
        case latestPrice = "latestPrice"
        case change = "change"
    }
}
