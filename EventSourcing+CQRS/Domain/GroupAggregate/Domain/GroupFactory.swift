//
//  GroupFactory.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation



protocol GroupFactory{
    func create(groupId: GroupId, grouName: GroupName, ownerId: UserId) -> Group
}
