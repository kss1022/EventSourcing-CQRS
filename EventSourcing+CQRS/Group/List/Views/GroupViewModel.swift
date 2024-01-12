//
//  GroupListViewModel.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation



struct GroupListViewModel: Hashable{
    let id: UUID
    let name: String
    
    init(_ model: GroupModel) {
        self.id = model.id
        self.name = model.name
    }
}
