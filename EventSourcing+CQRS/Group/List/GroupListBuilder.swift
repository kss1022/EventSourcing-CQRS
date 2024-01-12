//
//  GroupListBuilder.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import ModernRIBs

protocol GroupListDependency: Dependency {
    var groupRepository: GroupRepository{ get }
}

final class GroupListComponent: Component<GroupListDependency>, GroupListInteractorDependency {
    var groupRepository: GroupRepository{ dependency.groupRepository }
}

// MARK: - Builder

protocol GroupListBuildable: Buildable {
    func build(withListener listener: GroupListListener) -> GroupListRouting
}

final class GroupListBuilder: Builder<GroupListDependency>, GroupListBuildable {

    override init(dependency: GroupListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: GroupListListener) -> GroupListRouting {
        let component = GroupListComponent(dependency: dependency)
        let viewController = GroupListViewController()
        let interactor = GroupListInteractor(
            presenter: viewController,
            dependency: component
        )
        interactor.listener = listener
        return GroupListRouter(interactor: interactor, viewController: viewController)
    }
}
