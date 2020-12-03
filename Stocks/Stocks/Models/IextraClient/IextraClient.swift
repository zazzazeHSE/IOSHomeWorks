//
//  IextraManager.swift
//  Stocks
//
//  Created by Егор on 03.12.2020.
//

import Foundation

class IextraClient {
    private static let apiToken = "sk_4a9ac45eba3d4e6fbf7d3bfe0185cb84"
    static var symbol = ""
    enum Endpoints{
        static let base = "https://cloud.iexapis.com/stable/"
        static let apiTokenParam = "?token=\(apiToken)"
        case getStock
        case getImage
        case getAllStocks
        var stringValue: String{
            switch self {
                case .getStock: return "\(Endpoints.base)stock/\(symbol)/quote\(Endpoints.apiTokenParam)"
                
                case .getImage: return "\(Endpoints.base)stock/\(symbol)/logo\(Endpoints.apiTokenParam)"
                
                case .getAllStocks: return "\(Endpoints.base)ref-data/symbols\(Endpoints.apiTokenParam)"
            }
        }
        var url: URL{
            return URL(string: stringValue)!
        }
    }
}
