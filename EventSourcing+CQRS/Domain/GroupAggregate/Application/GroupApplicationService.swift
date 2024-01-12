//
//  GroupApplicationService.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation


final class GroupApplicationService: ApplicationService{
    
    internal let eventStore: EventStore
    internal let snapshotRepository: SnapshotRepository
    
    private let userService: UserService
    private let groupService: GroupService
    
    
    private let groupFactory: GroupFactory
    
    init(eventStore: EventStore, snapshotRepository: SnapshotRepository, userService: UserService, groupService: GroupService, groupFactory: GroupFactory) {
        self.eventStore = eventStore
        self.snapshotRepository = snapshotRepository
        self.userService = userService
        self.groupService = groupService
        self.groupFactory = groupFactory
    }
    
    func when(_ command: CreateGroup) async throws{
        do{
            let groupId = GroupId(UUID())
            let groupName = try GroupName(command.groupName)
            let ownerId = UserId(command.ownerId)
            
            
            if try groupService.exist(groupName: groupName){
                throw GroupException.canNotRegister(message: "Already registered group.")
            }
            
            
            let group = groupFactory.create(groupId: groupId, grouName: groupName, ownerId: ownerId)
            
            try eventStore.appendToStream(id: group.groupId.id, expectedVersion: -1, events: group.changes)
            
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    
    func when(_ command: JoinGroup) async throws{
        do{
            let memberId = UserId(command.memberId)
                                    
            try update(id: command.groupId) { (group: Group) in
                let specification = GroupFullSpecification()
                try group.join(member:  memberId, specification: specification)
            }
            
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    
    func when(_ command: RenameGroup) async throws{
        do{
            let groupName = try GroupName(command.groupName)
                                    
            try update(id: command.groupId) { (group: Group) in
                try group.rename(groupName: groupName)
            }
            
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    
    
}
