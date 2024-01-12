//
//  HomeRouter.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation
import ModernRIBs

protocol HomeInteractable: Interactable, UserListListener, UserJoinListener, GroupListListener, AddGroupListener, GroupUsersListener{
    var router: HomeRouting? { get set }
    var listener: HomeListener? { get set }
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol HomeViewControllable: ViewControllable {
    func setUserList(_ view: ViewControllable)
    func setGroupList(_ view: ViewControllable)
}

final class HomeRouter: ViewableRouter<HomeInteractable, HomeViewControllable>, HomeRouting {

    
    
    private let userListBuildable: UserListBuildable
    private var userListRouting: Routing?
    
    private let userJoinBuildable: UserJoinBuildable
    private var userJoinRouting: Routing?
    
    private let groupListBuildable: GroupListBuildable
    private var groupListRouting: Routing?
    
    private let addGroupBuildable: AddGroupBuildable
    private var addGroupRouting: Routing?
        
    private let groupUsersBuildable: GroupUsersBuildable
    private var groupUsersRouting: Routing?
    
    
    init(
        interactor: HomeInteractable,
        viewController: HomeViewControllable,
        userListBuildable: UserListBuildable,
        userJoinBuildable: UserJoinBuildable,
        groupListBuildable: GroupListBuildable,
        addGroupBuildable: AddGroupBuildable,
        groupUsersBuildable: GroupUsersBuildable
    ) {
        self.userListBuildable = userListBuildable
        self.userJoinBuildable = userJoinBuildable
        self.groupListBuildable = groupListBuildable
        self.addGroupBuildable = addGroupBuildable
        self.groupUsersBuildable = groupUsersBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachUserList() {
        if userListRouting != nil{
            return
        }
        
        
        let router = userListBuildable.build(withListener: interactor)
        viewController.setUserList(router.viewControllable)
        userListRouting = router
        attachChild(router)
    }
    
    func attachGroupList() {
        if groupListRouting != nil{
            return
        }
        
        let router = groupListBuildable.build(withListener: interactor)
        viewController.setGroupList(router.viewControllable)
        groupListRouting = router
        attachChild(router)
    }
    
    func attachAddGroup() {
        if addGroupRouting != nil{
            return
        }
        
        let router = addGroupBuildable.build(withListener: interactor)
        let navigation = NavigationControllerable(root: router.viewControllable)
        navigation.setLargeTitle()
        
        let nav = navigation.navigationController
        nav.presentationController?.delegate = interactor.presentationDelegateProxy
                
        viewController.present(navigation, animated: true, completion: nil)
        addGroupRouting = router
        attachChild(router)
    }
    
    func detachAddGroup() {
        guard let router = addGroupRouting else { return }
        
        viewController.dismiss(animated: true, completion: nil)
        detachChild(router)
        addGroupRouting = nil
    }
    
    
    func attachGroupUsers(groupId: UUID) {
        if groupUsersRouting != nil{
            return
        }
        
        let router = groupUsersBuildable.build(withListener: interactor, groupId: groupId)
        
        let navigation = NavigationControllerable(root: router.viewControllable)
        navigation.setLargeTitle()
        
        let nav = navigation.navigationController
        nav.presentationController?.delegate = interactor.presentationDelegateProxy
        
        viewController.present(navigation, animated: true, completion: nil)
        addGroupRouting = router
        attachChild(router)
    }
    
    func detachGroupUsers() {
        guard let router = groupUsersRouting else { return }
        
        viewController.dismiss(animated: true, completion: nil)
        detachChild(router)
        groupUsersRouting = nil
    }
    
    func attachUserJoin(userId: UUID) {
        if userJoinRouting != nil{
            return
        }
        
        let router = userJoinBuildable.build(withListener: interactor, userId: userId)
        let navigation = NavigationControllerable(root: router.viewControllable)
        navigation.setLargeTitle()
        
        let nav = navigation.navigationController
        nav.presentationController?.delegate = interactor.presentationDelegateProxy
        
        viewController.present(navigation, animated: true, completion: nil)
        userJoinRouting = router
        attachChild(router)
    }
    
    func detachUserJoin() {
        guard let router =  userJoinRouting else { return }
        viewController.dismiss(animated: true, completion: nil)
        detachChild(router)
        userJoinRouting = nil
    }

}
