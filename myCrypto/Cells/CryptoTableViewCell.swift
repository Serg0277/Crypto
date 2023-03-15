//
//  CryptoTableViewCell.swift
//  myCrypto
//
//  Created by  Сергей on 14.09.2022.
//

import UIKit

class CryptoTableViewCell: UITableViewCell {
    
    static let identifire = "CryptoTableViewCell"
    
    //Subview
    
    private let imageIcon : UIImageView = { //  иконка монеты
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .gray // цвет оттенка
        imageView.contentMode = .scaleAspectFit // вид заполнения
        imageView.layer.shadowOpacity = 0.7
        imageView.layer.shadowRadius = 5
        imageView.layer.cornerRadius = 30 //для закругленного или круглого изображения  необходимо чтобы рамка делилась на два тот параметр и ставить
        imageView.layer.masksToBounds = true // это для круглого изображения все три функции для аватаки
        imageView.layer.borderWidth = 2 // показывает рамку иногда очень нужно
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    private let nameLable : UILabel = { //  название монеты
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 24, weight: .medium)
        
        return lb
    }()
    
    private let symbolLable : UILabel = { //сокращенное  название монеты
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 24, weight: .regular)
        
        return lb
    }()
    
    private let priceLable : UILabel = { //стоимость монеты
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 20, weight: .semibold)
        lb.textAlignment = .right
        return lb
    }()
   
    //Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLable)
        contentView.addSubview(symbolLable)
        contentView.addSubview(priceLable)
        contentView.addSubview(imageIcon)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLable.sizeToFit()
        symbolLable.sizeToFit()
        priceLable.sizeToFit()
        
        imageIcon.frame = CGRect(x: 5, y: 5, width: contentView.frame.size.height-10, height: contentView.frame.size.height-10)
        
        nameLable.frame = CGRect(x: imageIcon.frame.width+10, y: 0, width: contentView.frame.size.width/2, height: contentView.frame.size.height/2)
        symbolLable.frame = CGRect(x: imageIcon.frame.width+10, y: contentView.frame.size.height/2, width: contentView.frame.size.width/2, height: contentView.frame.size.height/2)
        priceLable.frame = CGRect(x: contentView.frame.size.width/2, y: 0, width: (contentView.frame.size.width/2)-5, height: contentView.frame.size.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageIcon.image = nil
        nameLable.text = nil
        priceLable.text = nil
        symbolLable.text = nil
        
    }
    //Configure
    
    func configure(with viewModel:CryptoTableViewCellModel) {
        nameLable.text = viewModel.name
        symbolLable.text = viewModel.symbol
        priceLable.text = String(viewModel.price)
        
        //это типа кеширование тоесть емли картинки уже загружены то они заново не загружаются когда прокручиваем экран
        if let data = viewModel.iconData {
            imageIcon.image = UIImage(data: data)
            
        } else
    //так раньше  без верхнего было
        if let url = viewModel.iconUrl {
            let task = URLSession.shared.dataTask(with: url) { data, _, err in
                if let data = data {

                    DispatchQueue.main.async {
                        self.imageIcon.image = UIImage(data: data)
                    }
                }
            }
            task.resume()
        }
        
    }
    
}
