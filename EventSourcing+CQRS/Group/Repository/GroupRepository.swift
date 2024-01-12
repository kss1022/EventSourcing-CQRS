//
//  GroupRepository.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation
import Combine


protocol GroupRepository{
    var groups: ReadOnlyCurrentValuePublisher<[GroupModel]>{ get }
    var groupUsers: ReadOnlyCurrentValuePublisher<[GroupUserModel]>{ get }
    
    func fetchGroups() async throws
    func fetchGroupUsers(groupId: UUID) async throws
}


final class GroupRepositoryImp: GroupRepository{

    var groups: ReadOnlyCurrentValuePublisher<[GroupModel]>{ groupsSubject }
    private let groupsSubject =  CurrentValuePublisher<[GroupModel]>([])
        
    var groupUsers: ReadOnlyCurrentValuePublisher<[GroupUserModel]>{ groupUsersSubject}
    private let groupUsersSubject = CurrentValuePublisher<[GroupUserModel]>([])

    
    func fetchGroups() async throws {
        let groups = try groupReadModel.groups().map(GroupModel.init)
        Log.v("GroupeRepository: fetch groups")
        groupsSubject.send(groups)
    }
    
    func fetchGroupUsers(groupId: UUID) async throws {
        let groupUsers = try groupReadModel.groupUsers(groupId: groupId).map(GroupUserModel.init)
        Log.v("GroupeRepository: fetch groupUsers")
        groupUsersSubject.send(groupUsers)
    }
    
    private let groupReadModel: GroupReadModelFacade
    
    init(groupReadModel: GroupReadModelFacade) {
        self.groupReadModel = groupReadModel
        
        Task{
            try? await fetchGroups()
        }
         
    }
}

