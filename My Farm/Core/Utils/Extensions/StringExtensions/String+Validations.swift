//
//  String+Validations.swift
//  3oon
//
//  Created by mazen eldeeb on 11/02/2025.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        let regex = "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?" +
        ":[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|" +
        "\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]" +
        "*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|" +
        "\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?" +
        "|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\" +
        "x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }

    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var isValidStrongPassword: Bool {
        let regex = "(?=.*[\\$\"&+~,{}\\[\\]:;=\\\\\\\\?@#_|/'<>.`¿¡£€÷×^*()%!-])(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).*"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil && count >= 8
    }

    var isValidCardNumber: Bool {
          return self.count == 16 && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
      }

      var isValidPhoneNumber: Bool {
          return self.count >= 9 && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
      }

    var isValidCVV: Bool {
          return (self.count == 3 || self.count == 4) && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
      }

    var isNotContainEnglishCharacters: Bool {
        let regex = "^[A-Za-z ]+$"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) == nil
    }

    var isValidArabicName: Bool {
         let regex = "^[ء-ي ]+$"
         return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
     }

    var isNotContainArabicCharacters: Bool {
        let regex = "[\\u0600-\\u06FF\\u0750-\\u077F\\u08A0-\\u08FF]+"
        return range(of: regex, options: .regularExpression) == nil
    }

    var isValidEnglishName: Bool {
        let englishRegex = "^[A-Za-z ]+$"
        return range(of: englishRegex, options: .regularExpression) != nil
    }

    var isValidFullName: Bool {
        let components = self.components(separatedBy: .whitespaces)
        return components.count >= 3 && components.allSatisfy { !$0.isEmpty }
    }

    var isMoreThanEightChar: Bool {
        return count >= 8
    }

    var isUpperAndLowerCase: Bool {
        return range(of: "[A-Z]", options: .regularExpression) != nil
        && range(of: "[a-z]", options: .regularExpression) != nil
    }

    var isSpecialChar: Bool {
        let specialCharacters = "[\\$\"&+~,{}\\[\\]:;=\\\\?@#_|/'<>.`¿¡£€÷×^*()%!-]"
        return range(of: specialCharacters, options: .regularExpression) != nil
        && range(of: "[0-9]", options: .regularExpression) != nil
    }

    var isValidIqamaID: Bool {
         let pattern = "^2\\d{9}$"
         return range(of: pattern, options: .regularExpression) != nil
     }

    var isValidNationalID: Bool {
         let pattern = "^1\\d{9}$"
         return range(of: pattern, options: .regularExpression) != nil
     }

    var isValidNameSize: Bool {
        return count <= 50
    }

    var isValidIBAN: Bool {
        let pattern = "^[a-zA-Z0-9]{24}$"
        return self.range(of: pattern, options: .regularExpression) != nil
    }
}
