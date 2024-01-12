//
//  RenameGroup.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/12/24.
//

import Foundation



struct RenameGroup: Command{
    let groupId: UUID
    let groupName: String
}
