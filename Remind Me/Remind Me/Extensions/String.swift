//
//  String.swift
//  Remind Me
//
//  Created by Huy Gia on 29/9/24.
//

import Foundation

extension String {
    func isEmptyString() -> Bool {
        if self.trimmingCharacters(in: .whitespaces).isEmpty {
            return true
        } else {
            return false
        }
    }
}
