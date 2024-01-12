//
//  UserListRouter.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import ModernRIBs

protocol UserListInteractable: Interactable {
    var router: UserListRouting? { get set }
    var listener: UserListListener? { get set }
}

protocol UserListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class UserListRouter: ViewableRouter<UserListInteractable, UserListViewControllable>, UserListRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: UserListInteractable, viewController: UserListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
