//
//  IextraManager.swift
//  Stocks
//
//  Created by Егор on 03.12.2020.
//

import Foundation

class StocksClient: Client {
    private static let apiToken = "sk_4a9ac45eba3d4e6fbf7d3bfe0185cb84"
    private static let defaultStocks = [
        StockPreview(name: "Apple", symbol: "AAPL"),
        StockPreview(name: "Microsoft", symbol: "MSFT"),
        StockPreview(name: "Google", symbol: "GOOG"),
        StockPreview(name: "Amazon", symbol: "AMZN"),
        StockPreview(name: "Facebook", symbol: "FB")
    ]
    static var symbol = ""
    static var imageSymbol = ""
    private enum Endpoints{
        static let base = "https://cloud.iexapis.com/stable/"
        static let apiTokenParam = "?token=\(apiToken)"
        case getStock
        case getImage
        case getAllStocks
        private var stringValue: String{
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
    
    static func getData(completition: @escaping (_ stocks:[StockPreview]) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: Endpoints.getAllStocks.url) { data, response, error in
            if error != nil {
                completition(defaultStocks)
                return
            }
            
            let decoder = JSONDecoder()
            guard
                let data = data,
                let allStocks = try? decoder.decode([StockPreview].self, from: data)
            else {
                completition(defaultStocks)
                return
            }
            
            completition(allStocks)
        }
        
        dataTask.resume()
    }
    
    static func getSimpleStockImage(symbol: String, completition: @escaping (_ imageData: Data?) -> Void){
        self.imageSymbol = symbol
        let dataTask = URLSession.shared.dataTask(with: Endpoints.getImage.url) { data, response, error in
            if error != nil {
                completition(nil)
                return
            }
            
            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let urlString = json["url"] as? String,
                let url = URL(string: urlString)
            else {
                completition(nil)
                return
            }
            
            loadImage(url: url, completition: completition)
        }
        dataTask.resume()
    }
    
    private static func loadImage(url: URL, completition: @escaping (_ imageData: Data?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completition(nil)
                return
            }
            
            if let data = data {
                completition(data)
                return
            }
            
            completition(nil)
        }
        
        dataTask.resume()
    }
    
    static func getSimpleStock(symbol: String, completition: @escaping (_ stock: Stock?) -> Void) {
        self.symbol = symbol
        let dataTask = URLSession.shared.dataTask(with: Endpoints.getStock.url) { data, response, error in
            if error != nil {
                completition(nil)
                return
            }
            
            let decoder = JSONDecoder()
            guard
                let data = data,
                let stock = try? decoder.decode(Stock.self, from: data)
            else {
                completition(nil)
                return
            }
            
            completition(stock)
        }
        
        dataTask.resume()
    }
}
