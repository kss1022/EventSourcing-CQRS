//
//  CDGroupFactory.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation



struct CDGroupFactory: GroupFactory{
    func create(groupId: GroupId, grouName: GroupName, ownerId: UserId) -> Group {
        Group(groupId: groupId, grouName: grouName, ownerId: ownerId)
    }
}
