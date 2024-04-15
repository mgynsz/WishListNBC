//
//  VCPreview.swift
//  WishListNBC
//
//  Created by David Jang on 4/9/24.
//

import SwiftUI

struct VCPreview<T: UIViewController>: UIViewControllerRepresentable {
    
    let viewController: T
    
    init(_ viewControllerBuilder: @escaping () -> T) {
        viewController = viewControllerBuilder()
    }
    
    func makeUIViewController(context: Context) -> T {
        viewController
    }
    
    func updateUIViewController(_ uiViewController: T, context: Context) { }
}
