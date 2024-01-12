//
//  UserDao.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation



protocol UserDao{
    func save(_ dto: UserDto) throws
    func update(_ dto: UserDto) throws
    func find(_ id: UUID) throws -> UserDto?
    func find(_ name: String) throws -> UserDto?
    func findAll() throws -> [UserDto]
    func delete(_ id: UUID) throws
}
