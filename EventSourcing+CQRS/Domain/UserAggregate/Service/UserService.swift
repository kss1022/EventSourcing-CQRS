//
//  UserService.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation



final class UserService{
    
    
    private let userReadModel: UserReadModelFacade
    
    init(userReadModel: UserReadModelFacade) {
        self.userReadModel = userReadModel
    }
    
    func exist(userName: UserName) throws -> Bool{
        try userReadModel.user(name: userName.name) != nil
    }
        
    func exist(userId: UserId) throws -> Bool{
        try userReadModel.user(id: userId.id) != nil
    }
}
