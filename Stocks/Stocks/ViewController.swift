//
//  ViewController.swift
//  Stocks
//
//  Created by Егор on 02.12.2020.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    //MARK: - private properties
    private var companies: [String: String] = [:]
    
    //MARK: - UIPickerView data source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return companies.keys.count
    }
    

    //MARK: - View lifecycle
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var companyPickerView: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var compamyImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        companyNameLabel.sizeToFit()
        priceLabel.sizeToFit()
        symbolLabel.sizeToFit()
        priceChangeLabel.sizeToFit()
        
        companyPickerView.dataSource = self
        companyPickerView.delegate = self
        
        self.activityIndicator.hidesWhenStopped = true
        loadAvailableStocks()
    }
    
    //MARK: - UIPickerView delegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(companies.keys)[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        requestQuoteUpdate()
    }

    //MARK: - Private methods
    private func loadAvailableStocks(){
        activityIndicator.startAnimating()
        let url = IextraClient.Endpoints.getAllStocks.url
        let dataTask = URLSession.shared.dataTask(with: url){ data, error, response in
            guard let data = data
            else{
                print("Get all stocks error: \(error!.description)")
                self.setDefaultCompaniesAndUpdate()
                return
            }
            self.parseAvailableData(data: data)
        }
        dataTask.resume()
    }
    
    private func parseAvailableData(data: Data){
        do{
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            guard let jsonArray = jsonObject as? [Any]
            else{
                print("Parse json problems")
                self.setDefaultCompaniesAndUpdate()
                return
            }
            for item in jsonArray {
                guard let json = item as? [String : Any], let symbol = json["symbol"] as? String, let name = json["name"] as? String
                else {
                    print("Parse item problem")
                    self.setDefaultCompaniesAndUpdate()
                    return;
                }
                self.companies[name] = symbol
            }
            DispatchQueue.main.async {
                self.companyPickerView.reloadAllComponents()
            }
            self.requestQuoteUpdate()
        } catch {
            print("Parse available stocks data error: \(error.localizedDescription)")
        }
    }
    
    private func requestQuoteUpdate(){
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            
            self.companyNameLabel.text = "-"
            self.symbolLabel.text = "-"
            self.priceLabel.text = "-"
            self.priceChangeLabel.text = "-"
            self.priceChangeLabel.textColor = .black
            self.compamyImageView.image = nil
            let selectedRow = self.companyPickerView.selectedRow(inComponent: 0)
            let selectedSymbol = Array(self.companies.values)[selectedRow]
            self.requestQuote(for: selectedSymbol)
        }
    }
    
    private func requestQuote(for symbol: String){
        IextraClient.symbol = symbol
        let url = IextraClient.Endpoints.getStock.url
        let dataTask = URLSession.shared.dataTask(with: url){ data, response, error in
            guard error == nil, (response as? HTTPURLResponse)?.statusCode == 200, let data = data
            else{
                print("Network error")
                return
            }
            self.parseQuote(data: data)
            self.loadImage(symbol: symbol)
        }
        dataTask.resume()
    }
    
    private func loadImage(symbol: String){
        IextraClient.symbol = symbol
        let url = IextraClient.Endpoints.getImage.url
        let dataTask = URLSession.shared.dataTask(with: url){ data, response, error in
            guard error == nil, (response as? HTTPURLResponse)?.statusCode == 200, let data = data
            else{
                print("Get image error")
                return
            }
            self.parseImage(data: data)
        }
        dataTask.resume()
    }
    
    private func parseQuote(data: Data){
        do{
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            guard let json = jsonObject as? [String: Any],
                  let companyName = json["companyName"] as? String,
                  let companySymbol = json["symbol"] as? String,
                  let price = json["latestPrice"] as? Double,
                  let priceChange = json["change"] as? Double
            else{
                print("Json problems")
                return;
            }
            DispatchQueue.main.async {
                self.displayStockInfo(companyName: companyName, symbol: companySymbol, price: price, priceChange: priceChange)
            }
        } catch{
            print("Json parsing error: \(error.localizedDescription)")
        }
    }
    
    private func parseImage(data: Data){
        do{
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            guard let json = jsonObject as? [String: Any], let companyImageUrl = json["url"] as? String
            else {
                print("Image json problems")
                return;
            }
            displayStockImage(imageUrl: companyImageUrl)
        } catch {
            print("Parse image json error: \(error.localizedDescription)")
        }
    }
    
    private func fetchImage(imageUrl: String, completitionHandler: @escaping (_ data: Data?) -> ()){
        let url = URL(string: imageUrl)!
        let dataTask = URLSession.shared.dataTask(with: url){ data, response, error in
            if error != nil {
                print("Fetch image error: \(error!.localizedDescription)")
                completitionHandler(nil)
            } else {
                completitionHandler(data)
            }
        }
        dataTask.resume()
    }
    
    private func displayStockImage(imageUrl: String){
        fetchImage(imageUrl: imageUrl){ imageData in
            if let data = imageData{
                DispatchQueue.main.async {
                    self.compamyImageView.image = UIImage(data: data)
                }
            }
            else{
                print("Image data problems")
            }
        }
    }
    
    private func displayStockInfo(companyName: String, symbol: String, price: Double, priceChange: Double){
        self.activityIndicator.stopAnimating()
        self.companyNameLabel.text = companyName
        symbolLabel.text = symbol
        priceLabel.text = "\(price)$"
        priceChangeLabel.text = "\(priceChange)"
        if priceChange < 0 {
            priceChangeLabel.textColor = .red
        } else if priceChange > 0 {
            priceChangeLabel.textColor = .systemGreen
        } else {
            priceChangeLabel.textColor = .black
        }
    }
    
    private func setDefaultCompaniesAndUpdate(){
        self.companies = ["Apple" : "AAPL",
                     "Microsoft" : "MSFT",
                     "Google" : "GOOG",
                     "Amazon" : "AMZN",
                     "Facebook" : "FB"]
        companyPickerView.reloadAllComponents()
        requestQuoteUpdate()
    }
}

