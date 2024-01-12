//
//  UserModel.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation



struct UserModel{
    let id: UUID
    let name: String
    
    init(_ dto: UserDto) {
        self.id = dto.id
        self.name = dto.name
    }
}
