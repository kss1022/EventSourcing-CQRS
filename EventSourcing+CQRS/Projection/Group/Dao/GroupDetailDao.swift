//
//  GroupDetailDao.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation


protocol GroupUserDao{
    func save(_ dto: GroupUserDto) throws
    
    func updateGroup(id: UUID, name: String) throws
    func updateUser(id: UUID, name: String) throws
    
    func findByGroupId(_ groupId: UUID) throws -> [GroupUserDto]
    func findByUserId(_ userId: UUID) throws -> [GroupUserDto]
}
