//
//  GroupJoined.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation


final class GroupJoined: DomainEvent{
    let groupId: GroupId
    let groupName: GroupName
    let member: UserId
    
    init(groupId: GroupId, groupName: GroupName, member: UserId) {
        self.groupId = groupId
        self.groupName = groupName
        self.member = member
        super.init()
    }
    
    
    override func encode(with coder: NSCoder) {
        groupId.encode(with: coder)
        groupName.encode(with: coder)
        member.encode(with: coder)
        super.encode(with: coder)
    }
    
    override init?(coder: NSCoder) {
        guard let groupId = GroupId(coder: coder),
              let groupName = GroupName(coder: coder),
              let newMember = UserId(coder: coder) else { return nil }
        
        self.groupId = groupId
        self.groupName = groupName
        self.member = newMember
        super.init(coder: coder)
    }
    
    static var supportsSecureCoding: Bool = true

}
