//
//  APISession.swift
//  tinkoffNews
//
//  Created by Vitaliy Plaschenkov on 04.02.2023.
//

import Foundation
import UIKit

extension ViewController{

    func updateNews(completion: @escaping (Result<News, Error>) -> Void){
        let session = URLSession.shared
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=57bbb35b9c6c427b8d1a1d7b2aa3d270") else {
            return
        }
        DispatchQueue.global(qos: .utility).async {
            let task = session.dataTask( with: url) { (data, response, error) in

                if let error = error {
                    completion(.failure(error))
                }
                if let data = data {
                    print(data)
                do {
                    let decodedData = try JSONDecoder().decode(News.self, from: data)
//                    print(decodedData.articles.description)
                    completion(.success(decodedData))
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
        }
    }
    
    func fetch() {
        updateNews { result in
            switch result{
            case .success(let data):
                    self.articles = data.articles
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
 
}
