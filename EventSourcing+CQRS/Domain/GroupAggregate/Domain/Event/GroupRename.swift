//
//  GroupRename.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/12/24.
//

import Foundation



final class GroupRename: DomainEvent{
    let groupId: GroupId
    let groupName: GroupName
        
    init(groupId: GroupId, groupName: GroupName) {
        self.groupId = groupId
        self.groupName = groupName
        super.init()
    }
    
    
    override func encode(with coder: NSCoder) {
        groupId.encode(with: coder)
        groupName.encode(with: coder)
        super.encode(with: coder)
    }
    
    override init?(coder: NSCoder) {
        guard let groupId = GroupId(coder: coder),
              let groupName = GroupName(coder: coder) else { return nil}
        
        self.groupId = groupId
        self.groupName = groupName                
        super.init(coder: coder)
    }
    
    static var supportsSecureCoding: Bool = true

}
