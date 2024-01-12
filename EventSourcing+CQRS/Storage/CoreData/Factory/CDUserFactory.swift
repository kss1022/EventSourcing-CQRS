//
//  CDUserFactory.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation


final class CDUserFactory: UserFactory{
    func create(userId: UserId, userName: UserName) -> User {
        User(userId: userId, userName: userName)
    }
}
