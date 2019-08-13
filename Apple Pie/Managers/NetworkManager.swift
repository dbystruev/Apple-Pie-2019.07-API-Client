//
//  NetworkManager.swift
//  Apple Pie
//
//  Created by Denis Bystruev on 13/08/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import Foundation

class NetworkManager {
    let baseURL = URL(string: "http://localhost:8080/")!
    
    func loadCategories(completion: @escaping ([Category]?) -> Void) {
        let url = baseURL.appendingPathComponent("categories")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(#line, #function, "Can't get data from \(url.absoluteString)")
                completion(nil)
                return
            }
            
            let jsonDecoder = JSONDecoder()
            guard let categories = try? jsonDecoder.decode([Category].self, from: data) else {
                print(#line, #function, "Can't decode data from \(data)")
                completion(nil)
                return
            }
            
            completion(categories)
        }.resume()
    }
    
    func loadWords(for category: Category, completion: @escaping ([CategoryWord]?) -> Void) {
        let url = baseURL.appendingPathComponent("words").appendingPathComponent("\(category.id)")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(#line, #function, "Can't get data from \(url.absoluteString)")
                completion(nil)
                return
            }
            
            let jsonDecoder = JSONDecoder()
            guard let words = try? jsonDecoder.decode([CategoryWord].self, from: data) else {
                print(#line, #function, "Can't decode data from \(data)")
                completion(nil)
                return
            }
            
            completion(words)
        }.resume()
    }
}
