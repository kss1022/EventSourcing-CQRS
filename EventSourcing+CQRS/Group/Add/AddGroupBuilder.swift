//
//  AddGroupBuilder.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import ModernRIBs

protocol AddGroupDependency: Dependency {
    var groupApplicationService: GroupApplicationService{ get }
        
    var userRepository: UserRepository{ get }
    var groupRepository: GroupRepository{ get }
}

final class AddGroupComponent: Component<AddGroupDependency>, AddGroupInteractorDependency,UserListDependency {
    var groupApplicationService: GroupApplicationService{dependency.groupApplicationService}
        
    var userRepository: UserRepository{ dependency.userRepository }
    var groupRepository: GroupRepository{ dependency.groupRepository}
}

// MARK: - Builder

protocol AddGroupBuildable: Buildable {
    func build(withListener listener: AddGroupListener) -> AddGroupRouting
}

final class AddGroupBuilder: Builder<AddGroupDependency>, AddGroupBuildable {

    override init(dependency: AddGroupDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AddGroupListener) -> AddGroupRouting {
        let component = AddGroupComponent(dependency: dependency)
        let viewController = AddGroupViewController()
        let interactor = AddGroupInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        
        let userListBuilder = UserListBuilder(dependency: component)
        
        return AddGroupRouter(
            interactor: interactor,
            viewController: viewController,
            userListBuildable: userListBuilder
        )
    }
}
