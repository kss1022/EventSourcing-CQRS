//
//  AppRootComponent.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation
import ModernRIBs

final class AppRootComponent: Component<AppRootDependency>, AppRootInteractorDependency, HomeDependency, ProfileDependency {
    
    
    
    let userApplicationService: UserApplicationService
    let groupApplicationService: GroupApplicationService
    
    //MARK: ApplicationService
    private let rootViewController: AppRootViewController
    
    //MARK: ReadModel
    private let userReadModel: UserReadModelFacade
    private let groupReadModel: GroupReadModelFacade
    
    //MAKR: Projection
    private let userProjection: UserProjection
    private let groupProjection: GroupProjection
    
    //MARK: Repository
    let userRepository: UserRepository
    let groupRepository: GroupRepository
    
    init(
        dependency: AppRootDependency,
        viewController: AppRootViewController
    ){
        
        //Base Domain
        let appendOnlyStore = CDAppendOnlyStore()
        let eventStore = EventStoreImp(appendOnlyStore: appendOnlyStore)
        let snapshotRepository = CDSnapshotRepository()
        
        //Factory
        let userFactory = CDUserFactory()
        let groupFactory = CDGroupFactory()
                
        //ReadModel
        self.userReadModel = try! UserReadModelFacadeImp()
        self.groupReadModel = try! GroupReadModelFacadeImp()
        
        //Service
        let userService = UserService(userReadModel: userReadModel)
        let groupService = GroupService(groupReadModel: groupReadModel)

        //Projection
        self.userProjection = try! UserProjection()
        self.groupProjection = try! GroupProjection()
        
        
        
        //ApplicationService
        self.userApplicationService = UserApplicationService(
            eventStore: eventStore,
            snapshotRepository: snapshotRepository,
            userService: userService,
            userFactory: userFactory
        )
        
        self.groupApplicationService = GroupApplicationService(
            eventStore: eventStore,
            snapshotRepository: snapshotRepository,
            userService: userService,
            groupService: groupService,
            groupFactory: groupFactory
        )
        
        //Repository
        self.userRepository = UserRepositoryImp(userReadModel: userReadModel)
        self.groupRepository = GroupRepositoryImp(groupReadModel: groupReadModel)
        
        
        self.rootViewController = viewController
        super.init(dependency: dependency)
    }
}
