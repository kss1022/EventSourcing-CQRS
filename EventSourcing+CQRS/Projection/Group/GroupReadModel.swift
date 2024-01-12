//
//  GroupReadModel.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation



protocol GroupReadModelFacade{
    func group(id: UUID) throws -> GroupDto?
    func group(name: String) throws -> GroupDto?
    func groups() throws -> [GroupDto]
    
    func groupUsers(groupId: UUID) throws -> [GroupUserDto]
}


final class GroupReadModelFacadeImp: GroupReadModelFacade{
    
    private let groupDao: GroupDao
    private let groupUserDao: GroupUserDao
    
    
    init() throws{
        guard let dbManager = DatabaseManager.default else {
            throw DatabaseException.couldNotGetDatabaseManagerInstance
        }
        
        groupDao = dbManager.groupDao
        groupUserDao = dbManager.groupUserDao
    }
    
    func group(id: UUID) throws -> GroupDto? {
        try groupDao.find(id)
    }
    
    func group(name: String) throws -> GroupDto? {
        try groupDao.find(name)
    }
    
    func groups() throws -> [GroupDto] {
        try groupDao.findAll()
    }
    
    func groupUsers(groupId: UUID) throws -> [GroupUserDto] {
        try groupUserDao.findByGroupId(groupId)
    }
        
}
