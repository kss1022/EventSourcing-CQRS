//
//  GroupException.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation


enum GroupException: Error{
    case canNotRegister(message: String)
    case canNotJoin(message: String)
}


extension GroupException: LocalizedError{
    var errorDescription: String?{
        switch self {
        case .canNotRegister(let message): return message
        case .canNotJoin(let message): return message            
        }
    }
}
