//
//  CustomTableViewCell.swift
//  tinkoffNews
//
//  Created by Vitaliy Plaschenkov on 04.02.2023.
//

import UIKit

protocol Configurable {
    associatedtype Model
    func configure(model: Model)
}

class CustomTableViewCell: UITableViewCell {
    static let identefier = "CustomTableViewCell"
    
    lazy var imageNews: UIImageView = {
       let myImageView = UIImageView()
        myImageView.layer.cornerRadius = 20
        myImageView.clipsToBounds = true
        return myImageView
    }()
    
    lazy var newsTitle: UILabel = {
       let newsTitle = UILabel()
        newsTitle.textColor = .white
        newsTitle.numberOfLines = 0
        newsTitle.font = UIFont.systemFont(ofSize: 15)

        return newsTitle
    }()
    
    lazy var subTitle: UILabel = {
       let subTitle = UILabel()
        subTitle.textColor = .white
        subTitle.numberOfLines = 0
        subTitle.font = UIFont.systemFont(ofSize: 10)
        return subTitle
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .black
        contentView.addSubview(imageNews)
        contentView.addSubview(newsTitle)
        contentView.addSubview(subTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageNews.frame = CGRect(x: 5, y: 5, width: 100, height: contentView.frame.size.height - 10)
        newsTitle.frame = CGRect(x: 20 + imageNews.frame.size.width, y: 0, width: contentView.frame.size.width - imageNews.frame.size.width, height: imageNews.frame.size.height - 40)
        subTitle.frame = CGRect(x: 10 + imageNews.frame.size.width, y: newsTitle.frame.size.height - 5, width: contentView.frame.size.width - imageNews.frame.size.width - 5, height: imageNews.frame.size.height - 40)
    }
}


extension CustomTableViewCell: Configurable {

    struct Model {
        let name: String
        let description: String
        let image: String
    }

    func configure(model: Model) {
        newsTitle.text = model.name
        subTitle.text = model.description
        imageNews.imageFromServerURL(model.image, placeHolder: nil)    }
}


extension UIView {
    
    func addSubviews(_ views: [Any]) {
        views.forEach { if let view = $0 as? UIView {
            self.addSubview(view)
            }
        }
    }
    
    func pin(to superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
    }
}

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
  func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {
    image = nil
    let imageServerUrl = URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    
    if let cachedImage = imageCache.object(forKey: NSString(string: imageServerUrl)) {
      image = cachedImage
      return
    }
    
    let activityIndicator = self.configureActivityIndicator()
    addSubview(activityIndicator)
    activityIndicator.startAnimating()
    
    guard let url = URL(string: imageServerUrl) else { return }
    
    URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
      if error != nil {
        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          self.image = placeHolder
        }
        return
      }
      
      guard let data = data else { return }
      guard let downloadedImage = UIImage(data: data) else { return }
      
      imageCache.setObject(downloadedImage, forKey: NSString(string: imageServerUrl))
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        
        self.image = downloadedImage
        activityIndicator.removeFromSuperview()
      }
    }).resume()
  }
  
  private func configureActivityIndicator() -> UIActivityIndicatorView {
    let activityIndicator = UIActivityIndicatorView.init(style: .medium)
    activityIndicator.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    activityIndicator.center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
    activityIndicator.autoresizingMask = AutoresizingMask(rawValue: AutoresizingMask.RawValue(UInt8(AutoresizingMask.flexibleRightMargin.rawValue) | UInt8(AutoresizingMask.flexibleLeftMargin.rawValue) | UInt8(AutoresizingMask.flexibleBottomMargin.rawValue) | UInt8(AutoresizingMask.flexibleTopMargin.rawValue)))
    
    return activityIndicator
  }
}
