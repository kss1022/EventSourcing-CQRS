//
//  GroupUsersRouter.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/12/24.
//

import ModernRIBs

protocol GroupUsersInteractable: Interactable {
    var router: GroupUsersRouting? { get set }
    var listener: GroupUsersListener? { get set }
}

protocol GroupUsersViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class GroupUsersRouter: ViewableRouter<GroupUsersInteractable, GroupUsersViewControllable>, GroupUsersRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: GroupUsersInteractable, viewController: GroupUsersViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
