//
//  UserListInteractor.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation
import ModernRIBs
import Combine


protocol UserListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol UserListPresentable: Presentable {
    var listener: UserListPresentableListener? { get set }
    func setUsers(_ viewModels: [UserListViewModel])
}

protocol UserListListener: AnyObject {
    func userListDidSelectRowAt(userId: UUID)
}

protocol UserListInteractorDependency{
    var userRepository: UserRepository{ get }
}

final class UserListInteractor: PresentableInteractor<UserListPresentable>, UserListInteractable, UserListPresentableListener {

    weak var router: UserListRouting?
    weak var listener: UserListListener?

    private let dependency: UserListInteractorDependency
    private let userRepository: UserRepository
    
    private var cancellables: Set<AnyCancellable>
    
    init(
        presenter: UserListPresentable,
        dependency: UserListInteractorDependency
    ) {
        self.dependency = dependency
        self.userRepository = dependency.userRepository
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        
        userRepository.users
            .receive(on: DispatchQueue.main)
            .sink { users in
                let viewModels = users.map(UserListViewModel.init)
                self.presenter.setUsers(viewModels)
            }
            .store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func didSelectRowAt(userId: UUID) {
        listener?.userListDidSelectRowAt(userId: userId)
    }
}
