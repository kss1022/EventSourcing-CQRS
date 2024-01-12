//
//  RenameUser.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation



struct RenameUser: Command{
    let userId: UUID
    let userName: String
}
