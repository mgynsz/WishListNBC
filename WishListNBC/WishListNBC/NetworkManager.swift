//
//  NetworkManager.swift
//  WishListNBC
//
//  Created by David Jang on 4/9/24.
//

import Foundation
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    
    func getAllProducts() async throws -> [Model] {
        guard let url = URL(string: "https://dummyjson.com/products") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let productsResponse = try JSONDecoder().decode(ProductsResponse.self, from: data)
        
        // 전체 제품(100개) 가져와서 섞고 30개 배열에 담기
        let shuffledProducts = productsResponse.products.shuffled()
        let randomProducts = Array(shuffledProducts.prefix(30))
        
        return randomProducts
    }
}
