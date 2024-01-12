//
//  GroupDao.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation


protocol GroupDao{
    func save(_ dto: GroupDto) throws
    func update(_ dto: GroupDto) throws
    func updateGroup(id: UUID, name: String) throws
    func updateOwner(id: UUID, name: String) throws
    func find(_ id: UUID) throws -> GroupDto?
    func find(_ name: String) throws -> GroupDto?
    func findAll() throws -> [GroupDto]
    func delete(_ id: UUID) throws
}
