//
//  GroupCreated.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation



final class GroupCreated: DomainEvent{
    let groupId: GroupId
    let groupName: GroupName
    let ownerId: UserId
    
    init(groupId: GroupId, groupName: GroupName, ownerId: UserId) {
        self.groupId = groupId
        self.groupName = groupName
        self.ownerId = ownerId
        super.init()
    }
    
    
    override func encode(with coder: NSCoder) {
        groupId.encode(with: coder)
        groupName.encode(with: coder)
        ownerId.encode(with: coder)
        super.encode(with: coder)
    }
    
    override init?(coder: NSCoder) {
        guard let groupId = GroupId(coder: coder),
              let groupName = GroupName(coder: coder),
              let ownerId = UserId(coder: coder) else { return nil}
        
        self.groupId = groupId
        self.groupName = groupName
        self.ownerId = ownerId
        super.init(coder: coder)
    }
    
    static var supportsSecureCoding: Bool = true

}
