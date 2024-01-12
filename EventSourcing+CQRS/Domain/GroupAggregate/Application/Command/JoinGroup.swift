//
//  JoinGroup.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation



struct JoinGroup: Command{
    let groupId: UUID
    let memberId: UUID
}
