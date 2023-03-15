//
//  ViewController.swift
//  myCrypto
//
//  Created by  Сергей on 14.09.2022.
// API Called
//UI to show different cryptos
//MVVM

import UIKit

class ViewController: UIViewController {
    
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(CryptoTableViewCell.self, forCellReuseIdentifier: CryptoTableViewCell.identifire)
        return tableView
    }()
    
    private var viewModels = [CryptoTableViewCellModel]()
    
    //форматирование под валюту
    static let numberFormatted: NumberFormatter = {
        let formated = NumberFormatter()
        formated.locale = .current //текущий
        formated.allowsFloats = true
        formated.formatterBehavior = .default //поумолчанию
        formated.numberStyle = .currency //валюта
        return formated
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        title = "Crypto Tracker"
        tableView.dataSource = self
        tableView.delegate = self
        
        //функция интернет запроса возвращает результат в виде декодированного массива типа
        APICaller.shared.getAllCryptoData { [weak self] result in
            switch result {
            case .success(let models):
                //     compactMap делает плоским или обединяет массивы пропуская nill значения
                self?.viewModels = models.compactMap({model in
                    
                    //для красоты форматируем число чтоб доллар был
                    let price = model.price_usd
                    let priceFormatter = ViewController.numberFormatted.string(from: NSNumber(value: price ?? 0.0))
                    
                  
                    
                    
                    //load icons еще и фильтр массива
                    let iconUrl = URL(string: APICaller.shared.iconsArray.filter { icon in
                        icon.asset_id == model.asset_id
                    }.first?.url ?? "")
                    
                  
                    // так как замкание пишем return не пойму почему именно такой тип
                    return CryptoTableViewCellModel(
                        name: model.name ?? "",
                        symbol: model.asset_id,
                        price: String(priceFormatter ?? "N/A"),
                        iconUrl: iconUrl)
                })
                
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print("Ошибка :\(error)")
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CryptoTableViewCell.identifire, for: indexPath) as! CryptoTableViewCell
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
