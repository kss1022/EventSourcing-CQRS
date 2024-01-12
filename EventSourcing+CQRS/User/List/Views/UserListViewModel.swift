//
//  UserListViewModel.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation



struct UserListViewModel: Hashable{
    let id: UUID
    let name: String
    
    init(_ model: UserModel) {
        self.id = model.id
        self.name = model.name
    }
}
