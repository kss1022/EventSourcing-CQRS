//
//  UserSQLDao.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation
import SQLite


final class UserSQLDao: UserDao{
    
    private let db : Connection
    private let table: Table
    
    // MARK: Columns
    internal static let tableName = "UserDao"
    private let userId: Expression<UUID>
    private let userName: Expression<String>
    
    
    init(db: Connection) throws{
        self.db = db
        
        table = Table(UserSQLDao.tableName)
        userId = Expression<UUID>("userId")
        userName = Expression<String>("userName")
    
        
        try setup()
    }
    
    internal static func dropTable(db: Connection) throws{
        try db.execute("DROP TABLE IF EXISTS \(UserSQLDao.tableName)")
        Log.v("DROP Table: \(UserSQLDao.tableName )")
    }
    
    private func setup() throws{
        try db.run(table.create(ifNotExists: true){ table in
            table.column(userId, primaryKey: true)
            table.column(userName)
        })
        db.userVersion = 0
        Log.v("Create Table (If Not Exists): \(UserSQLDao.tableName)")
    }
    
    func save(_ dto: UserDto) throws {
        let insert = table.insert(
            userId <- dto.id,
            userName <- dto.name
        )
        try db.run(insert)
        Log.v("Insert \(UserDto.self): \(dto)")
    }
    
    func update(_ dto: UserDto) throws {
        let query = table.filter(userId == dto.id)
            .limit(1)

        let update = query.update(
            userName <- dto.name
        )
        
        try db.run(update)
        Log.v("Update \(UserDto.self): \(dto)")
    }
    
    func find(_ id: UUID) throws -> UserDto? {
        let query = table.filter(userId == id)
            .limit(1)

        return try db.pluck(query)
            .map{
                UserDto(
                    id: $0[userId],
                    name: $0[userName]
                )
            }
    }
    
    func find(_ name: String) throws -> UserDto? {
        let query = table.filter(userName == name)
            .limit(1)

        return try db.pluck(query)
            .map{
                UserDto(
                    id: $0[userId],
                    name: $0[userName]
                )
            }
    }
    
    func findAll() throws -> [UserDto] {
        try db.prepareRowIterator(table).map { 
            UserDto(
                id: $0[userId],
                name: $0[userName]
            )
        }
    }
    
    func delete(_ id: UUID) throws {
        let query = table.filter(userId == id)
            .limit(1)
        
        try db.run(query.delete())
        Log.v("Delete \(UserDto.self): \(id)")
    }
    
    
}
