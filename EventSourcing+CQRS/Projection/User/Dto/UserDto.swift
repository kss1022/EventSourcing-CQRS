//
//  UserDto.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation



struct UserDto{
    let id: UUID
    let name: String
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
    
    init(_ event: UserCreated){
        self.id = event.userId.id
        self.name = event.userName.name
    }
}
