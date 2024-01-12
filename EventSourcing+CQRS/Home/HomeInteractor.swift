//
//  HomeInteractor.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation
import ModernRIBs

protocol HomeRouting: ViewableRouting {
    func attachUserList()
    func attachGroupList()
    
    func attachUserJoin(userId: UUID)
    func detachUserJoin()
    
    func attachAddGroup()
    func detachAddGroup()
    
    func attachGroupUsers(groupId: UUID)
    func detachGroupUsers()
}

protocol HomePresentable: Presentable {
    var listener: HomePresentableListener? { get set }
    
    func showAddAlert()
    func showAddUserAlert()
}

protocol HomeListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol HomeInteractorDependency{
    var userApplicationService: UserApplicationService{ get }
    var userRepository: UserRepository{ get }
}

final class HomeInteractor: PresentableInteractor<HomePresentable>, HomeInteractable, HomePresentableListener, AdaptivePresentationControllerDelegate {
        
    weak var router: HomeRouting?
    weak var listener: HomeListener?
    
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy

    private let dependency: HomeInteractorDependency
    
    private let userApplicationService: UserApplicationService
    private let userRepository: UserRepository
    
    
    private var isAddGroupPresented: Bool
    private var isUserJoinPresented: Bool
    private var isGroupUserPresented: Bool
    
    init(
        presenter: HomePresentable,
        dependency: HomeInteractorDependency
    ) {
        self.dependency = dependency
        self.presentationDelegateProxy = .init()
        self.userApplicationService = dependency.userApplicationService
        self.userRepository = dependency.userRepository
        
        isAddGroupPresented = false
        isUserJoinPresented = false
        isGroupUserPresented = false
        
        super.init(presenter: presenter)
        presenter.listener = self
        presentationDelegateProxy.delegate = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        router?.attachUserList()
        router?.attachGroupList()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func addBarButtonTap() {
        presenter.showAddAlert()
    }
    
    func addUserActionTap() {
        presenter.showAddUserAlert()
    }
    
    func addUser(userName: String) {
        let command = CreateUser(userName: userName)
        
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                try await userApplicationService.when(command)
                try await userRepository.fetchUsers()
            }catch{
                Log.v(error.localizedDescription)
            }
        }
    }
    
    
    func presentationControllerDidDismiss() {        
        if isUserJoinPresented{
            router?.detachUserJoin()
            isUserJoinPresented = false
            return
        }
        
        
        if isAddGroupPresented{
            router?.detachAddGroup()
            isAddGroupPresented = false
            return
        }
        
        router?.detachGroupUsers()
        isGroupUserPresented = false
    }
    
    
    // MARK: UserList
    func userListDidSelectRowAt(userId: UUID) {
        router?.attachUserJoin(userId: userId)
        isUserJoinPresented = true
    }
    
    // MARK: UserJoin
    func userJoinDidCloseButtonTap() {
        router?.detachUserJoin()
        isUserJoinPresented = false
    }
    
    func userJoinDidJoin() {
        router?.detachUserJoin()
        isUserJoinPresented = false
    }
    
    
    // MARK: AddGroup
    func addGroupActionTap() {
        router?.attachAddGroup()
        isAddGroupPresented = true
    }
    
    func addGroupCloseButtonDidTap() {
        router?.detachAddGroup()
        isAddGroupPresented = false
    }
    
    func addGroupDidAddGroup() {
        router?.detachAddGroup()
        isAddGroupPresented = true
    }

    // MARK: GroupList
    func groupListDidSelectRowAt(groupId: UUID) {
        router?.attachGroupUsers(groupId: groupId)
        isGroupUserPresented = true
    }
    
    func groupUserCloseButtonDidtap() {
        router?.detachGroupUsers()
        isGroupUserPresented = false
    }
    
    
  
 
    
}
