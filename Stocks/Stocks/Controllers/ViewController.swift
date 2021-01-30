//
//  ViewController.swift
//  Stocks
//
//  Created by Егор on 02.12.2020.
//

import UIKit

class ViewController: UIViewController {
    var selectedStock: Stock? {
        didSet {
            updateStockInfo()
        }
    }
    
    var allStocks: [StockPreview]?
    
    var suitableStocks: [StockPreview]? {
        didSet {
            updatePickerView()
        }
    }
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var companyPickerView: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var compamyImageView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePickerView()
        searchTextField.delegate = self
        self.activityIndicator.hidesWhenStopped = true
        loadData()
    }
    
    private func loadData() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        
        StocksClient.getData() { data in
            self.allStocks = data
            self.suitableStocks = data
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func configurePickerView() {
        companyPickerView.dataSource = self
        companyPickerView.delegate = self
    }
    
    private func updatePickerView() {
        DispatchQueue.main.async {
            self.companyPickerView.reloadAllComponents()
            self.loadSelectedStock()
        }
    }
    
    private func loadSelectedStock() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        
        self.selectedStock = nil
        DispatchQueue.main.async {
            let selectedRow = self.companyPickerView.selectedRow(inComponent: 0)
            if selectedRow > self.suitableStocks!.count || self.suitableStocks!.count == 0{
                return
            }
            let selectedSymbol = self.suitableStocks![selectedRow].symbol
            StocksClient.getSimpleStock(symbol: selectedSymbol){ data in
                if data == nil {
                    DispatchQueue.main.async {
                        self.showAlert(title: "Network error", text: "Cannot get stock info")
                    }
                }
                self.selectedStock = data
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    private func updateStockInfo(){
        guard let stock = selectedStock else {
            DispatchQueue.main.async{
                self.companyNameLabel.text = "-"
                self.symbolLabel.text = "-"
                self.priceLabel.text = "-"
                self.priceChangeLabel.text = "-"
                self.priceChangeLabel.textColor = .black
                self.compamyImageView.image = nil
            }
            
            return
        }
        
        StocksClient.getSimpleStockImage(symbol: stock.symbol) { data in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Network error", text: "Cannot download image")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.compamyImageView.image = UIImage(data: data)
            }
        }
        
        DispatchQueue.main.async {
            self.companyNameLabel.text = stock.companyName
            self.symbolLabel.text = stock.symbol
            self.priceLabel.text = "\(stock.latestPrice)$"
            self.priceChangeLabel.text = "\(stock.change)"
            
            switch stock.change {
            case let x where x < 0:
                self.priceChangeLabel.textColor = .red
                break
            case let x where x > 0:
                self.priceChangeLabel.textColor = .systemGreen
                break
            default:
                self.priceChangeLabel.textColor = .black
            }
        }
    }
    
    @IBAction func searchDidEnd(_ sender: Any) {
        guard let allStocks = allStocks else {
            return
        }
        
        let searchText = searchTextField.text!
        let selectedStocks = allStocks.filter{ $0.name.lowercased().starts(with: searchText.lowercased()) }
        
        suitableStocks = selectedStocks
    }
    
    @IBAction func onChanging(_ sender: Any) {
        if searchTextField.text!.isEmpty {
            suitableStocks = allStocks
        }
    }
    
    private func showAlert(title: String, text: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - UIPickerViewDelegate
extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let suitableStocks = suitableStocks else {
            return ""
        }
        
        return suitableStocks[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        loadSelectedStock()
    }
}

//MARK: - UIPickerViewDataSource
extension ViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard  let suitableStocks = suitableStocks else {
            return 0
        }
        
        return suitableStocks.count
    }
    
}

//MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
