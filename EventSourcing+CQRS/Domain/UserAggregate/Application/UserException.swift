//
//  UserException.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation


enum UserException: Error{
    case canNotRegister(message: String)
}

extension UserException: LocalizedError{
    var errorDescription: String?{
        switch self {
        case .canNotRegister(let message):
            return message
        }        
    }
}
