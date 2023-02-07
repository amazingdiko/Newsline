//
//  FullInfoViewController.swift
//  tinkoffNews
//
//  Created by Vitaliy Plaschenkov on 05.02.2023.
//

import UIKit
//import WebKit

class FullInfoViewController: UIViewController {
    
    var url: String = ""
    var name: String = ""
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .black
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var newsTitle: UILabel = {
       let newsTitle = UILabel()
        newsTitle.textColor = .white
        newsTitle.numberOfLines = 0
        newsTitle.translatesAutoresizingMaskIntoConstraints = false
        newsTitle.font = UIFont.systemFont(ofSize: 20)
        
        return newsTitle
    }()
    
    private var subTitle: UILabel = {
        let subTitle = UILabel()
        subTitle.textColor = .white
        subTitle.numberOfLines = 0
        subTitle.translatesAutoresizingMaskIntoConstraints = false
        subTitle.font = UIFont.systemFont(ofSize: 15)
         return subTitle
     }()
    
    private var date: UILabel = {
        let date = UILabel()
        date.textColor = .white
        date.numberOfLines = 0
        date.translatesAutoresizingMaskIntoConstraints = false
        date.font = UIFont.systemFont(ofSize: 15)
         return date
     }()
    
    private var author: UILabel = {
        let author = UILabel()
        author.textColor = .white
        author.numberOfLines = 0
        author.translatesAutoresizingMaskIntoConstraints = false
        author.font = UIFont.systemFont(ofSize: 15)
         return author
     }()
    
    private var urlLabel: UILabel = {
        let urlLabel = UILabel()
        urlLabel.textColor = .white
        urlLabel.numberOfLines = 0
        urlLabel.translatesAutoresizingMaskIntoConstraints = false
        urlLabel.font = UIFont.systemFont(ofSize: 17)
        urlLabel.text = "Full text u can read here: "
         return urlLabel
     }()
    
    private var imageNews: UIImageView = {
        let myImageView = UIImageView()
        myImageView.layer.cornerRadius = 20
        myImageView.clipsToBounds = true
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        return myImageView
    }()
    
    private var button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func addView(){
        view.addSubview(scrollView)
        scrollView.addSubview(newsTitle)
        scrollView.addSubview(subTitle)
        scrollView.addSubview(imageNews)
        scrollView.addSubview(author)
        scrollView.addSubview(date)
        scrollView.addSubview(urlLabel)
        scrollView.addSubview(button)
        button.setTitle(url, for: .normal)
        button.addTarget(self, action: #selector(tapNews), for: .touchUpInside)
    }
    
    private func addTargetTapNews(url: String, name: String){
        guard let url = URL(string: url) else {
            return
        }
        let vc = WebViewViewController(url: url, title: name)
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    @objc private func tapNews(){
        addTargetTapNews(url: url, name: name)
    }
    
    private func setupConstraintLabel() {
         var constraints = [NSLayoutConstraint]()
        
        constraints.append(scrollView.topAnchor.constraint(equalTo: view.topAnchor))
        constraints.append(scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        constraints.append(scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        
        
        constraints.append(imageNews.heightAnchor.constraint(equalToConstant: 250))
        constraints.append(imageNews.topAnchor.constraint(equalTo: newsTitle.topAnchor, constant: 80))
        constraints.append(imageNews.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20))
        constraints.append(imageNews.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20))
        
        constraints.append(newsTitle.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40))
        constraints.append(newsTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20))
        constraints.append(newsTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20))
        
        constraints.append(subTitle.topAnchor.constraint(equalTo: imageNews.bottomAnchor, constant: 40))
        constraints.append(subTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20))
        constraints.append(subTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20))
        
        constraints.append(date.topAnchor.constraint(equalTo: subTitle.bottomAnchor, constant: 10))
        constraints.append(date.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20))
        
        constraints.append(author.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 0))
        constraints.append(author.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20))

        
        constraints.append(urlLabel.topAnchor.constraint(equalTo: author.bottomAnchor, constant: 20))
        constraints.append(urlLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20))
        
        constraints.append(button.topAnchor.constraint(equalTo: urlLabel.bottomAnchor, constant: -5))
        constraints.append(button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15))
        constraints.append(button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0))
        constraints.append(urlLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20))
        
        NSLayoutConstraint.activate(constraints)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addView()
        setupConstraintLabel()
    }
}


extension FullInfoViewController: Configurable {

    struct Model {
        let name: String
        let content: String
        let image: String
        let url: String
        let author: String
        let date: String
    }

    func configure(model: Model) {
        newsTitle.text = model.name
        subTitle.text = model.content
        author.text = model.author
        date.text = model.date
        url = model.url
        name = model.name
        imageNews.imageFromServerURL(model.image, placeHolder: nil)   }
}
