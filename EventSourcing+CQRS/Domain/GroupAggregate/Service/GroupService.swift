//
//  GroupService.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation



class GroupService{
    
    private let groupReadModel: GroupReadModelFacade
    
    init(groupReadModel: GroupReadModelFacade) {
        self.groupReadModel = groupReadModel
    }

    func exist(groupName: GroupName) throws -> Bool{
        try groupReadModel.group(name: groupName.name) != nil
    }
    
    func exist(groupId: GroupId) throws -> Bool{
        try groupReadModel.group(id: groupId.id) != nil
    }
}
