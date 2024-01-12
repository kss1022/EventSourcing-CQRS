//
//  GroupUsersBuilder.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/12/24.
//

import Foundation
import ModernRIBs

protocol GroupUsersDependency: Dependency {
    var groupRepository: GroupRepository{ get }
}

final class GroupUsersComponent: Component<GroupUsersDependency>, GroupUsersInteractorDependency {
    var groupRepository: GroupRepository{ dependency.groupRepository }
}

// MARK: - Builder

protocol GroupUsersBuildable: Buildable {
    func build(withListener listener: GroupUsersListener, groupId: UUID) -> GroupUsersRouting
}

final class GroupUsersBuilder: Builder<GroupUsersDependency>, GroupUsersBuildable {

    override init(dependency: GroupUsersDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: GroupUsersListener, groupId: UUID) -> GroupUsersRouting {
        let component = GroupUsersComponent(dependency: dependency)
        let viewController = GroupUsersViewController()
        let interactor = GroupUsersInteractor(presenter: viewController, dependency: component, groupId: groupId)
        interactor.listener = listener
        return GroupUsersRouter(interactor: interactor, viewController: viewController)
    }
}
