//
//  Utility.swift
//  MacDonald's
//
//  Created by David Jang on 4/4/24.
//

import Foundation

// Int -> String
extension Numeric {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}
