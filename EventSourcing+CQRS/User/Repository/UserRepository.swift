//
//  UserRepository.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation
import Combine


protocol UserRepository{
    var users: ReadOnlyCurrentValuePublisher<[UserModel]>{ get }
    
    func fetchUsers() async throws
}


final class UserRepositoryImp: UserRepository{
    
    var users: ReadOnlyCurrentValuePublisher<[UserModel]>{ usersSubject }
    private let usersSubject =  CurrentValuePublisher<[UserModel]>([])
    
    private let userReadModel: UserReadModelFacade
    
    func fetchUsers() async throws {
        let users = try userReadModel.users().map(UserModel.init)
        Log.v("RoutineRepository: fetch users")
        usersSubject.send(users)
    }
    
    init(userReadModel: UserReadModelFacade) {
        self.userReadModel = userReadModel
        
        Task{
            try? await fetchUsers()
        }
         
    }
}
