//
//  GroupSQLDao.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation
import SQLite

final class GroupSQLDao: GroupDao{

    private let db : Connection
    private let table: Table
    
    // MARK: Columns
    internal static let tableName = "GroupDao"
    private let groupId: Expression<UUID>
    private let groupName: Expression<String>
    private let ownerId: Expression<UUID>
    private let ownerName: Expression<String>
    
    
    init(db: Connection) throws{
        self.db = db
        
        table = Table(GroupSQLDao.tableName)
        groupId = Expression<UUID>("groupId")
        groupName = Expression<String>("groupName")
        ownerId = Expression<UUID>("ownerId")
        ownerName = Expression<String>("ownerName")
        
        try setup()
    }
    
    internal static func dropTable(db: Connection) throws{
        try db.execute("DROP TABLE IF EXISTS \(GroupSQLDao.tableName)")
        Log.v("DROP Table: \(GroupSQLDao.tableName )")
    }
    
    private func setup() throws{
        try db.run(table.create(ifNotExists: true){ table in
            table.column(groupId, primaryKey: true)
            table.column(groupName)
            table.column(ownerId)
            table.column(ownerName)
        })
        db.userVersion = 0
        Log.v("Create Table (If Not Exists): \(GroupSQLDao.tableName)")
    }
    
    func save(_ dto: GroupDto) throws {
        let insert = table.insert(
            groupId <- dto.id,
            groupName <- dto.name,
            ownerId <- dto.ownerId,
            ownerName <- dto.ownerName
        )
        try db.run(insert)
        Log.v("Insert \(GroupDto.self): \(dto)")
    }
    
    func update(_ dto: GroupDto) throws {
        let query = table.filter(groupId == dto.id)
            .limit(1)

        let update = query.update(
            groupName <- dto.name
        )
        
        try db.run(update)
        Log.v("Update \(GroupDto.self): \(dto)")
    }
    
    func updateGroup(id: UUID, name: String) throws {
        let query = table.filter(groupId == id)
            .limit(1)

        let update = query.update(
            groupName <- name
        )
        
        try db.run(update)
        Log.v("UpdateName \(GroupDto.self): (\(id) \(name))")
    }
    
    func updateOwner(id: UUID, name: String) throws {
        let query = table.filter(ownerId == id)
            .limit(1)

        let update = query.update(
            ownerName <- name
        )
        
        try db.run(update)
        Log.v("UpdateName \(GroupDto.self): (\(id) \(name))")
    }
    
        
    func find(_ id: UUID) throws -> GroupDto? {
        let query = table.filter(groupId == id)
            .limit(1)

        return try db.pluck(query)
            .map{
                GroupDto(
                    id: $0[groupId],
                    name: $0[groupName],
                    ownerId: $0[ownerId],
                    ownerName: $0[ownerName]
                )
            }
    }
    
    func find(_ name: String) throws -> GroupDto? {
        let query = table.filter(groupName == name)
            .limit(1)

        return try db.pluck(query)
            .map{
                GroupDto(
                    id: $0[groupId],
                    name: $0[groupName],
                    ownerId: $0[ownerId],
                    ownerName: $0[ownerName]
                )
            }
    }
    
    func findAll() throws -> [GroupDto] {
        try db.prepareRowIterator(table).map {
            GroupDto(
                id: $0[groupId],
                name: $0[groupName],
                ownerId: $0[ownerId],
                ownerName: $0[ownerName]
            )
        }
    }
    
    func delete(_ id: UUID) throws {
        let query = table.filter(groupId == id)
            .limit(1)
        
        try db.run(query.delete())
        Log.v("Delete \(GroupDto.self): \(id)")
    }
    
    
}

