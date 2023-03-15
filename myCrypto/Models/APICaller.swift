//
//  APICaller.swift
//  myCrypto
//
//  Created by  Сергей on 14.09.2022.
//

import Foundation

private struct Constants {
    static let apiKey = "5BE507A4-8187-4A70-A22B-A31668D366AB"
    static let acssetsEndpoint = "https://rest.coinapi.io/v1/assets/"
}
//"https://rest.coinapi.io/v1/assets/?apikey=5BE507A4-8187-4A70-A22B-A31668D366AB"
//"https://rest.coinapi.io/v1/assets/icons/55/?apikey=5BE507A4-8187-4A70-A22B-A31668D366AB"
final class APICaller {
    
    static let shared = APICaller()
    
    private init () {}
    
    public var iconsArray: [Icon] = []
    
    //это сделанно для того чтобы проверять когда загрузятся иконтки ждать нипонятно
    private var whenReadyBloc: ((Result<[Crypto], Error>) -> Void)?
    
    //MARK: - Public
    
    public func getAllCryptoData(completion: @escaping (Result<[Crypto], Error>) -> Void){
        
        //проверяем загрузились ли значки из сети
        guard !iconsArray.isEmpty else {
            //это все сделано для проверки и паузы пока не загрузятся иконки
            whenReadyBloc = completion
            return
        }
        
        //стандартный запрос в сеть с получением данных либо ошибки
        guard let url = URL(string: Constants.acssetsEndpoint + "?apikey=" + Constants.apiKey) else {return}
        //стандартный запрос в сеть с получением данных либо ошибки
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data, error == nil else {
                return
            }
            do {
                //Расшифровка ответа data и запись его в Crypto а после присвоение константе let cryptos
                let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                //сортировка массива от большего к меньшему
                let cryptosSorted = cryptos.sorted
                { first, second in
                    first.price_usd ?? 0 > second.price_usd ?? 0
                }
                completion(.success(cryptosSorted))
            }catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    //загрузка всех иконок из интернета в массив или словарь а далее поиск по нему и загрузка
    //вызов этой функции поставили а AppDelegate
    public func getAllIcons() {
        
        guard let url = URL(string: "https://rest.coinapi.io/v1/assets/icons/55/?apikey=5BE507A4-8187-4A70-A22B-A31668D366AB") else {return}
        //стандартный запрос в сеть с получением данных либо ошибки
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            
            guard let data = data, error == nil else {
                return
            }
            do {
                //Расшифровка ответа data и запись его в Crypto а после присвоение константе let cryptos
                self?.iconsArray = try JSONDecoder().decode([Icon].self, from: data)
                
                //это что вроде паузы ждем когда загрузятся иконки и тогда сообщаем что можно двигаться дальше
                if let completion = self?.whenReadyBloc {
                    self?.getAllCryptoData(completion: completion)
                }
                
            }catch {
                print("Ошибка загрузки иконок крипты!:\(error)")
            }
        }
        task.resume()
    }
    
}
