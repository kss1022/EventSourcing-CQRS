//
//  HomeBuilder.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import ModernRIBs

protocol HomeDependency: Dependency {
    var userApplicationService: UserApplicationService{ get }
    var groupApplicationService: GroupApplicationService{ get }
    
    var userRepository: UserRepository{ get }
    var groupRepository: GroupRepository{ get }
}

final class HomeComponent: Component<HomeDependency>, HomeInteractorDependency, UserListDependency, UserJoinDependency, GroupListDependency, AddGroupDependency, GroupUsersDependency {
    var userApplicationService: UserApplicationService{ dependency.userApplicationService }
    var groupApplicationService: GroupApplicationService{ dependency.groupApplicationService }
    
    var userRepository: UserRepository{ dependency.userRepository }
    var groupRepository: GroupRepository{ dependency.groupRepository }
}

// MARK: - Builder

protocol HomeBuildable: Buildable {
    func build(withListener listener: HomeListener) -> HomeRouting
}

final class HomeBuilder: Builder<HomeDependency>, HomeBuildable {

    override init(dependency: HomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: HomeListener) -> HomeRouting {
        let component = HomeComponent(dependency: dependency)
        let viewController = HomeViewController()
        
        let interactor = HomeInteractor(
            presenter: viewController,
            dependency: component
        )
        
        interactor.listener = listener
        
        let userListBuilder = UserListBuilder(dependency: component)
        let userJoinBuilder = UserJoinBuilder(dependency: component)
        let groupListBuilder = GroupListBuilder(dependency: component)
        let addGroupBuilder = AddGroupBuilder(dependency: component)
        let groupUserBuilder = GroupUsersBuilder(dependency: component)
        
        return HomeRouter(
            interactor: interactor,
            viewController: viewController,
            userListBuildable: userListBuilder,
            userJoinBuildable: userJoinBuilder,
            groupListBuildable: groupListBuilder,
            addGroupBuildable: addGroupBuilder, 
            groupUsersBuildable: groupUserBuilder
        )
    }
}
