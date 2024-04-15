//
//  Model.swift
//  WishListNBC
//
//  Created by David Jang on 4/9/24.
//

import Foundation

struct Model: Codable {
    
    let id: Int     // 홈 화면에 표시, 위시리스트 셀 관리에 활용 (동일 제품 중복 셀 생성 방지)
    let title: String
    let productDescription: String
    let price: Int
    let thumbnail: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, price, thumbnail
        case productDescription = "description"     // 코딩키 사용으로 키워드와 중복 오류 해결
    }
}

struct ProductsResponse: Codable {
    let products: [Model]
}

//: JSON
/*
 
 {
 "id": 1,
 "title": "iPhone 9",
 "description": "An apple mobile which is nothing like apple",
 "price": 549,
 "discountPercentage": 12.96,
 "rating": 4.69,
 "stock": 94,
 "brand": "Apple",
 "category": "smartphones",
 "thumbnail": "https://i.dummyjson.com/data/products/1/thumbnail.jpg",
 "images": [
 "https://i.dummyjson.com/data/products/1/1.jpg",
 "https://i.dummyjson.com/data/products/1/2.jpg",
 "https://i.dummyjson.com/data/products/1/3.jpg",
 "https://i.dummyjson.com/data/products/1/4.jpg",
 "https://i.dummyjson.com/data/products/1/thumbnail.jpg"
 ]
 }
 
 */
