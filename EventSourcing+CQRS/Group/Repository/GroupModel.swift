//
//  GroupModel.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation



struct GroupModel{
    let id: UUID
    let name: String
    let ownderId: UUID
    let ownderName: String
    
    init(_ dto: GroupDto) {
        self.id = dto.id
        self.name = dto.name
        self.ownderId = dto.ownerId
        self.ownderName = dto.ownerName
    }
}
