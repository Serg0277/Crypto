//
//  Models.swift
//  myCrypto
//
//  Created by  Сергей on 14.09.2022.
//

import Foundation

//структура для получения данных из сети идентична структуе на сайте
struct Crypto: Codable {
    let asset_id: String
    let name: String?
    let price_usd: Double?
    let id_icon: String?
}
//структура для получения данных для ячейки  было так а теперь сделали кеширование
//struct CryptoTableViewCellModel {
//    let name: String
//    let symbol: String
//    let price : String
//    let iconUrl: URL?
//}

class CryptoTableViewCellModel {
    let name: String
    let symbol: String
    let price : String
    let iconUrl: URL?
    //это не понятно как туда данные попадают
    var iconData: Data?
    
    init (name: String, symbol: String, price : String, iconUrl: URL? ) {
    self.name = name
    self.symbol = symbol
    self.price = price
    self.iconUrl = iconUrl
    
    }
}

//структура или модель загрузки значков из сети поэтому не забываем : Codable
struct Icon: Codable  {
    let asset_id: String
    let url: String
}





