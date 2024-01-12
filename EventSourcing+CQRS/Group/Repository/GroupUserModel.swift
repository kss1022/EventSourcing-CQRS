//
//  GroupUserModel.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/12/24.
//

import Foundation



struct GroupUserModel{
    let id: UUID
    let name: String
    let groupId: UUID
    
    init(_ dto: GroupUserDto) {
        self.id = dto.userId
        self.name = dto.userName
        self.groupId = dto.groupId
    }
}
