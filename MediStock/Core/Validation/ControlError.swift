//
//  ControlError.swift
//  MediStock
//
//  Created by Bruno Evrard on 25/05/2025.
//

import Foundation

enum ControlError: Error {
    case mailEmpty(message: String = AppMessages.emailEmpty)
    case invalidFormatMail(message: String = AppMessages.invalidFormatMail)
    case passwordEmpty(message: String = AppMessages.passwordEmpty)
    case passwordNotMatch(message: String = AppMessages.passwordNotMatch)
    case invalidPassword(message: String = AppMessages.invalidPassword)
    case nameEmpty(message: String = AppMessages.nameEmpty)
    case genericError(message: String = AppMessages.genericError)
    case emptyField(message: String = AppMessages.emptyField)
    
    
    var message: String {
        switch self {
        case .mailEmpty(let message),
                .invalidFormatMail(let message),
                .passwordEmpty(let message),
                .genericError(let message),
                .nameEmpty(let message),
                .passwordNotMatch(let message),
                .invalidPassword(message: let message),
                .emptyField(message: let message):
            return message
            
        }
    }
    
}


