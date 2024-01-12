//
//  GroupListRouter.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import ModernRIBs

protocol GroupListInteractable: Interactable {
    var router: GroupListRouting? { get set }
    var listener: GroupListListener? { get set }
}

protocol GroupListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class GroupListRouter: ViewableRouter<GroupListInteractable, GroupListViewControllable>, GroupListRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: GroupListInteractable, viewController: GroupListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
