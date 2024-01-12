//
//  UserListBuilder.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import ModernRIBs

protocol UserListDependency: Dependency {
    var userRepository: UserRepository{ get }
}

final class UserListComponent: Component<UserListDependency>, UserListInteractorDependency {
    var userRepository: UserRepository{ dependency.userRepository }
}

// MARK: - Builder

protocol UserListBuildable: Buildable {
    func build(withListener listener: UserListListener) -> UserListRouting
}

final class UserListBuilder: Builder<UserListDependency>, UserListBuildable {

    override init(dependency: UserListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: UserListListener) -> UserListRouting {
        let component = UserListComponent(dependency: dependency)
        let viewController = UserListViewController()
        let interactor = UserListInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return UserListRouter(interactor: interactor, viewController: viewController)
    }
}
