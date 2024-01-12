//
//  GroupUserSQLDao.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation
import SQLite


final class GroupUserSQLDao: GroupUserDao{

    private let db : Connection
    private let table: Table
    
    // MARK: Columns
    internal static let tableName = "GroupUser"
    private let groupId: Expression<UUID>
    private let groupName: Expression<String>
    private let userId: Expression<UUID>
    private let userName: Expression<String>
    
    
    init(db: Connection) throws{
        self.db = db
        
        table = Table(GroupUserSQLDao.tableName)
        groupId = Expression<UUID>("groupId")
        groupName = Expression<String>("groupName")
        userId = Expression<UUID>("userId")
        userName = Expression<String>("userName")
        
        
        try setup()
    }
    
    internal static func dropTable(db: Connection) throws{
        try db.execute("DROP TABLE IF EXISTS \(GroupUserSQLDao.tableName)")
        Log.v("DROP Table: \(GroupUserSQLDao.tableName )")
    }
    
    private func setup() throws{
        
        let userTable = Table(UserSQLDao.tableName)
        let groupTable = Table(GroupSQLDao.tableName)        

        
        try db.run(table.create(ifNotExists: true){ table in
            table.column(groupId)
            table.column(groupName)
            table.column(userId)
            table.column(userName)                        
            
            table.foreignKey(userId, references: userTable, userId, delete: .cascade)
            table.foreignKey(groupId, references: groupTable, groupId, delete: .cascade)
        })
        db.userVersion = 0
        Log.v("Create Table (If Not Exists): \(GroupUserSQLDao.tableName)")
    }

    
    func save(_ dto: GroupUserDto) throws {
        let insert = table.insert(
            groupId <- dto.groupId,
            groupName <- dto.groupName,
            userId <- dto.userId,
            userName <- dto.userName
        )
        try db.run(insert)
        Log.v("Insert \(GroupUserDto.self): \(dto)")
    }
    
    func updateGroup(id: UUID, name: String) throws {
        let query = table.filter(groupId == id)
        
        let update = query.update(
            groupName <- name
        )
        
        try db.run(update)
        Log.v("UpdateGroup \(GroupUserDto.self): (\(id), \(name))")
    }
    
    func updateUser(id: UUID, name: String) throws {
        let query = table.filter(userId == id)
        
        let update = query.update(
            groupName <- name
        )
        
        try db.run(update)
        Log.v("UpdateUser \(GroupUserDto.self): (\(id), \(name))")
    }
    
    
    func findByGroupId(_ groupId: UUID) throws -> [GroupUserDto] {
        let query = table.filter(self.groupId == groupId)

        return try db.prepareRowIterator(query).map {
            GroupUserDto(
                groupId: $0[self.groupId],
                groupName: $0[groupName],
                userId: $0[userId],
                userName: $0[userName]
            )
        }
    }
    
    func findByUserId(_ userId: UUID) throws -> [GroupUserDto] {
        let query = table.filter(self.userId == userId)

        return try db.prepareRowIterator(query).map {
            GroupUserDto(
                groupId: $0[groupId],
                groupName: $0[groupName],
                userId: $0[self.userId],
                userName: $0[userName]
            )
        }
    }
    
}

