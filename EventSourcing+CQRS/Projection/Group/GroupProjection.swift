//
//  GroupProjection.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation
import Combine


final class GroupProjection{
    private let userDao: UserDao
    private let groupDao: GroupDao
    private let groupUserDao: GroupUserDao
    
    private var cancellables: Set<AnyCancellable>
    
    
    init() throws{
        guard let dbManager = DatabaseManager.default else {
            throw DatabaseException.couldNotGetDatabaseManagerInstance
        }
        
        userDao = dbManager.userDao
        groupDao = dbManager.groupDao
        groupUserDao = dbManager.groupUserDao
        
        cancellables = .init()
        
        registerReceiver()
    }
    
    private func registerReceiver(){
        DomainEventPublihser.shared
            .onReceive(GroupCreated.self, action: when)
            .store(in: &cancellables)
        
        
        DomainEventPublihser.shared
            .onReceive(GroupJoined.self, action: when)
            .store(in: &cancellables)
        
        DomainEventPublihser.shared
            .onReceive(UserRename.self, action: when)
            .store(in: &cancellables)
        
    }
    
    private func when(_ event: GroupCreated){
        do{
            if let find = try userDao.find(event.ownerId.id){
                let group = GroupDto(
                    id: event.groupId.id,
                    name: event.groupName.name,
                    ownerId: find.id,
                    ownerName: find.name
                )
                                
                try groupDao.save(group)
            }
        }catch{
            Log.e("EventHandler Error: GroupCreated \(error)")
        }
    }
    
    private func when(_ event: GroupJoined){
        do{
            if let find = try userDao.find(event.member.id){
                let owner = GroupUserDto(
                    groupId: event.groupId.id,
                    groupName: event.groupName.name,
                    userId: find.id,
                    userName: find.name
                )
                                
                try groupUserDao.save(owner)
            }
        }catch{
            Log.e("EventHandler Error: GroupCreated \(error)")
        }
    }
    
    private func when(_ event: GroupRename){
        do{
            let groupId = event.groupId.id
            let groupName = event.groupName.name
            
            try groupDao.updateGroup(id: groupId, name: groupName)
            try groupUserDao.updateGroup(id: groupId, name: groupName)
        }catch{
            Log.e("EventHandler Error: GroupCreated \(error)")
        }
    }
    
    private func when(_ event: UserRename){
        do{
            let userId = event.userId.id
            let userName = event.userName.name
            try groupDao.updateOwner(id: userId, name: userName)
            try groupUserDao.updateUser(id: userId, name: userName)
        }catch{
            Log.e("EventHandler Error: UserRename \(error)")
        }
    }

}
