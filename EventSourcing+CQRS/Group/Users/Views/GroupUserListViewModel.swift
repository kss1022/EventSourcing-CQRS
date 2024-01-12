//
//  GroupUserListViewModel.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/12/24.
//

import Foundation



struct GroupUserListViewModel: Hashable{
    let id: UUID
    let name: String
    
    init(_ model: GroupUserModel) {
        self.id = model.id
        self.name = model.name
    }
}
