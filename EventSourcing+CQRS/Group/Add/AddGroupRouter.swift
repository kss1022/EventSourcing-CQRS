//
//  AddGroupRouter.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import ModernRIBs

protocol AddGroupInteractable: Interactable, UserListListener {
    var router: AddGroupRouting? { get set }
    var listener: AddGroupListener? { get set }
}

protocol AddGroupViewControllable: ViewControllable {
    func setUserLists(_ view: ViewControllable)
}

final class AddGroupRouter: ViewableRouter<AddGroupInteractable, AddGroupViewControllable>, AddGroupRouting {
    
    private let userListBuildable: UserListBuildable
    private var userListRouting: Routing?
    
    
    init(
        interactor: AddGroupInteractable,
        viewController: AddGroupViewControllable,
        userListBuildable: UserListBuildable
    ) {
        self.userListBuildable = userListBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachUserList() {
        if userListRouting != nil{
            return
        }
        
        
        let router = userListBuildable.build(withListener: interactor)
        viewController.setUserLists(router.viewControllable)        
        attachChild(router)
        userListRouting = router
    }

}
