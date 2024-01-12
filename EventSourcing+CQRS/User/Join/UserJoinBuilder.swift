//
//  UserJoinBuilder.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/12/24.
//

import Foundation
import ModernRIBs

protocol UserJoinDependency: Dependency {
    var groupApplicationService: GroupApplicationService{ get }
    var groupRepository: GroupRepository{ get }
}

final class UserJoinComponent: Component<UserJoinDependency>, UserJoinInteractorDependency, GroupListDependency {
    var groupApplicationService: GroupApplicationService{ dependency.groupApplicationService }
    var groupRepository: GroupRepository{ dependency.groupRepository }
}

// MARK: - Builder

protocol UserJoinBuildable: Buildable {
    func build(withListener listener: UserJoinListener, userId: UUID) -> UserJoinRouting
}

final class UserJoinBuilder: Builder<UserJoinDependency>, UserJoinBuildable {

    override init(dependency: UserJoinDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: UserJoinListener, userId: UUID) -> UserJoinRouting {
        let component = UserJoinComponent(dependency: dependency)
        let viewController = UserJoinViewController()
        let interactor = UserJoinInteractor(presenter: viewController, dependency: component, userId: userId)
        interactor.listener = listener
        
        
        let groupListBuilder = GroupListBuilder(dependency: component)
        
        return UserJoinRouter(
            interactor: interactor,
            viewController: viewController,
            groupListBuildable: groupListBuilder
        )
    }
}
