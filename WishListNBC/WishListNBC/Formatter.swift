//
//  Formatter+.swift
//  MacDonald's
//
//  Created by YJ on 4/5/24.
//

import Foundation

// 숫자 단위 구분점
extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
