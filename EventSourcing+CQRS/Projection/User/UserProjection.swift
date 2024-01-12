//
//  UserProjection.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation
import Combine



final class UserProjection{
    
    private let userDao: UserDao
    
    private var cancellables: Set<AnyCancellable>
    
    
    init() throws{
        guard let dbManager = DatabaseManager.default else {
            throw DatabaseException.couldNotGetDatabaseManagerInstance
        }
        
        userDao = dbManager.userDao
        
        cancellables = .init()
        
        registerReceiver()
    }
    
    private func registerReceiver(){
        DomainEventPublihser.shared
            .onReceive(UserCreated.self, action: when)
            .store(in: &cancellables)
        
        
        DomainEventPublihser.shared
            .onReceive(UserRename.self, action: when)
            .store(in: &cancellables)
        
        DomainEventPublihser.shared
            .onReceive(UserDeleted.self, action: when)
            .store(in: &cancellables)
    }
    
    private func when(_ event: UserCreated){
        do{
            let dto = UserDto(event)
            try userDao.save(dto)
        }catch{
            Log.e("EventHandler Error: UserCreated \(error)")
        }
    }
    
    private func when(_ event: UserRename){
        
    }
    
    private func when(_ event: UserDeleted){
        
    }
}


