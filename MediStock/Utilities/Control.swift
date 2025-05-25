//
//  Control.swift
//  MediStock
//
//  Created by Bruno Evrard on 25/05/2025.
//

import Foundation
import UIKit

/// Controls the input of the different views of the application
public struct Control  {
    
    
    static func signIn(email: String, password: String) throws (ControlError) {
        try validateEmail(email)
        guard !password.isEmpty else {
            throw ControlError.passwordEmpty()
        }
    }
    
    static func signUp(email: String, password: String, confirmedPassword: String, name: String) throws (ControlError) {
        try validateEmail(email)
        guard !password.isEmpty else {
            throw ControlError.passwordEmpty()
        }
        if (!isValidPassword(password: password)) {
            throw ControlError.invalidPassword()
        }
        
        guard password == confirmedPassword else {
            throw ControlError.passwordNotMatch()
        }
        guard !name.isEmpty else {
            throw ControlError.nameEmpty()
        }
    }
    
    private static func validateEmail(_ email: String) throws (ControlError) {
        guard !email.isEmpty else {
            throw ControlError.mailEmpty()
        }
        
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        
        guard emailPredicate.evaluate(with: email) else {
            throw ControlError.invalidFormatMail()
        }
    }
    
    private static func isValidPassword(password: String) -> Bool {
        // least one uppercase,
        // least one digit
        // least one lowercase
        // least one symbol
        //  min 8 characters total
        let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: password)

    }
}
