//
//  String+Extension.swift
//  3oon
//
//  Created by mazen eldeeb on 09/02/2025.
//

import Foundation

extension String {
    var localized: String {
        return String(localized: String.LocalizationValue(self))
    }
}
