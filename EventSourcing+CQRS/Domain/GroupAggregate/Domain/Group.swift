//
//  Group.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation



final class Group: DomainEntity{
    
    private(set) var groupId: GroupId!
    private(set) var groupName: GroupName!
    private(set) var ownerId: UserId!
    private(set) var members: Members!
    
    init(groupId: GroupId, grouName: GroupName, ownerId: UserId) {
        self.groupId = groupId
        self.groupName = grouName
        self.ownerId = ownerId
        self.members = Members([])
        super.init()
        
        let event = GroupCreated(groupId: groupId, groupName: groupName, ownerId: ownerId)
        changes.append(event)
    }
    
    required init(_ events: [Event]) {
        super.init(events)
    }
    
    override func mutate(_ event: Event) {
        if let created = event as? GroupCreated{
            when(created)
        }else if let joined = event as? GroupJoined{
            when(joined)
        }else if let rename = event as? GroupRename{
            when(rename)
        }else{
            Log.e("Event is not handling")
        }
    }
    
    func when(_ event: GroupCreated){
        self.groupId = event.groupId
        self.groupName = event.groupName
        self.ownerId = event.ownerId
        self.members = Members([])
    }
    
    func when(_ event: GroupJoined){        
        self.members = try! self.members.insert(event.member)
    }
    
    func when(_ event: GroupRename){
        self.groupName = event.groupName
    }
    
    func join(member: UserId, specification: GroupFullSpecification) throws{
        if !specification.isSatisfiedBy(self.members){
            throw GroupException.canNotJoin(message: "Maximum number of people in the group")
        }
        
        if member == ownerId{
            throw GroupException.canNotJoin(message: "Join Member is Owner")
        }
        
        
        self.members = try self.members.insert(member)
        let event = GroupJoined(groupId: self.groupId, groupName: self.groupName, member: member)
        changes.append(event)
    }
    
    func rename(groupName: GroupName) throws{
        self.groupName = groupName
        let event = GroupRename(groupId: self.groupId, groupName: groupName)
        changes.append(event)
    }
    
    override func encode(with coder: NSCoder) {
        groupId.encode(with: coder)
        groupName.encode(with: coder)
        ownerId.encode(with: coder)
        members.encode(with: coder)
        super.encode(with: coder)
    }
    
    override init?(coder: NSCoder) {
        guard let groupId = GroupId(coder: coder),
              let groupName = GroupName(coder: coder),
              let ownerId = UserId(coder: coder),
              let members = Members(coder: coder) else { return nil}
        
        self.groupId = groupId
        self.groupName = groupName
        self.ownerId = ownerId
        self.members = members
        super.init(coder: coder)
    }
    
    static var supportsSecureCoding: Bool = true
    
    
}
