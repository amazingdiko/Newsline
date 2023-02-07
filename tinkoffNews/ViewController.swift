//
//  ViewController.swift
//  tinkoffNews
//
//  Created by Vitaliy Plaschenkov on 04.02.2023.
//

import UIKit

class ViewController: UIViewController {
    
    
    var news = News()
    var articles: [Articles] = []
//    var array1 = [Articles?](repeating: nil, count: 20)
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identefier)
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
        addView()
        checkInternet()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    func addView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identefier, for: indexPath) as? CustomTableViewCell else {
            fatalError()
        }
        let element = articles[indexPath.row]
        cell.configure(model: .init(name: element.title, description: element.description, image: element.urlToImage))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 80
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let element = articles[indexPath.row]
        let vc = FullInfoViewController()
        vc.configure(model: .init(name: element.title, content: element.content, image: element.urlToImage, url: element.url, author: element.author, date: element.publishedAt))
        navigationController?.pushViewController(vc, animated: true)
    }
}

