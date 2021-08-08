//
//  File.swift
//  EtsyManager
//
//  Created by Анастасия Беспалова on 06.08.2021.
//

import Foundation

func convertSpecialCharacters(string: String) -> String {
        var newString = string
        let char_dictionary = [
            "&amp;" : "&",
            "&lt;" : "<",
            "&gt;" : ">",
            "&quot;" : "\"",
            "&apos;" : "'",
            "&#39;" : "'"
        ];
        for (escaped_char, unescaped_char) in char_dictionary {
            newString = newString.replacingOccurrences(of: escaped_char, with: unescaped_char, options: NSString.CompareOptions.literal, range: nil)
        }
        return newString
}

extension Date {
    /**
     Formats a Date

     - parameters format: (String) for eg dd-MM-yyyy hh-mm-ss
     */
    func format(format:String = "dd-MM-yyyy hh-mm-ss") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: self)
        if let newDate = dateFormatter.date(from: dateString) {
            return newDate
        } else {
            return self
        }
    }
}
