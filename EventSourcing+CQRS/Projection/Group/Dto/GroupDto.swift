//
//  GroupDto.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation


struct GroupDto{
    let id: UUID
    let name: String
    let ownerId: UUID
    let ownerName: String
    
    init(id: UUID, name: String, ownerId: UUID, ownerName: String) {
        self.id = id
        self.name = name
        self.ownerId = ownerId
        self.ownerName = ownerName
    }
}
