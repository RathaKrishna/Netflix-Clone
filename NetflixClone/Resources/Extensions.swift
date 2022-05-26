//
//  Extensions.swift
//  NetflixClone
//
//  Created by Rathakrishnan Ramasamy on 25/05/22.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
