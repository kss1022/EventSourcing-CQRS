//
//  UserFactory.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation



protocol UserFactory{
    func create(userId: UserId , userName: UserName) -> User
}
