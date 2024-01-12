//
//  UserApplicationService.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation



public final class UserApplicationService: ApplicationService{
    
    internal let eventStore: EventStore
    internal let snapshotRepository: SnapshotRepository
    
    private let userService: UserService
    private let userFactory: UserFactory
    
    init(eventStore: EventStore, snapshotRepository: SnapshotRepository, userService: UserService, userFactory: UserFactory) {
        self.eventStore = eventStore
        self.snapshotRepository = snapshotRepository
        self.userService = userService
        self.userFactory = userFactory
    }
    
    func when(_ command: CreateUser) async throws{
        do{
            Log.v("When (\(CreateUser.self)):  \(command)")

            let userId = UserId(UUID())
            let userName = try UserName(command.userName)
                        
            let user = userFactory.create(userId: userId, userName: userName)
            
            if try userService.exist(userName: userName){
                throw UserException.canNotRegister(message: "Already registered user.")
            }
            
            try eventStore.appendToStream(id: user.userId.id, expectedVersion: -1, events: user.changes)

            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    
    func when(_ command: RenameUser) async throws{
        do{
            Log.v("When (\(RenameUser.self)):  \(command)")
            
            let userName = try UserName(command.userName)
            
            try update(id: command.userId) { (user: User) in
                user.rename(userName: userName)
            }
            
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    
    func when(_ command: DeleteUser) async throws{
        do{
            Log.v("When (\(DeleteUser.self)):  \(command)")
          
            
            try update(id: command.userId) { (user: User) in
                user.delete()
            }
            
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    
    
    
}


