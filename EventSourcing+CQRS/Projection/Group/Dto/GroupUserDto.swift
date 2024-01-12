//
//  GroupUserDto.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation


struct GroupUserDto{
    let groupId: UUID
    let groupName: String
    let userId: UUID
    let userName: String    
    
    init(groupId: UUID, groupName: String, userId: UUID, userName: String) {
        self.groupId = groupId
        self.groupName = groupName
        self.userId = userId
        self.userName = userName
    }        
}
