//
//  UserJoinRouter.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/12/24.
//

import ModernRIBs

protocol UserJoinInteractable: Interactable, GroupListListener {
    var router: UserJoinRouting? { get set }
    var listener: UserJoinListener? { get set }
}

protocol UserJoinViewControllable: ViewControllable {
    func setGroupLists(_ view: ViewControllable)
}

final class UserJoinRouter: ViewableRouter<UserJoinInteractable, UserJoinViewControllable>, UserJoinRouting {

    private let groupListBuildable: GroupListBuildable
    private var groupListRouting: GroupListRouting?
    
    init(
        interactor: UserJoinInteractable,
        viewController: UserJoinViewControllable,
        groupListBuildable: GroupListBuildable
    ) {
        self.groupListBuildable = groupListBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachGroupList() {
        if groupListRouting != nil{
            return
        }
        
        let router = groupListBuildable.build(withListener: interactor)
        viewController.setGroupLists(router.viewControllable)
        attachChild(router)
        groupListRouting = router        
    }
    
}
