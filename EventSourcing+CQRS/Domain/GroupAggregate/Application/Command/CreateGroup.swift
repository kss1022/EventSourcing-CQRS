//
//  CreateGroup.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation



struct CreateGroup: Command{    
    let ownerId: UUID
    let groupName: String
}
