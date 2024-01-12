//
//  UserReadModel.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation


protocol UserReadModelFacade{
    func user(id: UUID) throws -> UserDto?
    func user(name: String) throws -> UserDto?
    func users() throws-> [UserDto]
}


final class UserReadModelFacadeImp: UserReadModelFacade{
    
    private let userDao: UserDao
    
    init() throws {
        guard let dbManager = DatabaseManager.default else {
            throw DatabaseException.couldNotGetDatabaseManagerInstance
        }
        
        userDao = dbManager.userDao
    }

    
    func user(id: UUID) throws -> UserDto? {
        try userDao.find(id)
    }
    
    func user(name: String) throws -> UserDto? {
        try userDao.find(name)
    }
    
    
    func users() throws -> [UserDto] {
        try userDao.findAll()
    }

}
