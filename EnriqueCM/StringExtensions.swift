//
//  StringExtensions.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 4/24/16.
//  Copyright © 2016 Enrique Choynowski Melgarejo. All rights reserved.
//

import UIKit

extension String {
    func isHexColor() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$", options: [])
            return regex.numberOfMatchesInString(self, options: NSMatchingOptions(), range: NSRange(location: 0, length: self.characters.count)) > 0
        } catch {
            return false
        }
    }
}
