//
//  UserJoinInteractor.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/12/24.
//

import Foundation
import ModernRIBs

protocol UserJoinRouting: ViewableRouting {
    func attachGroupList()
}

protocol UserJoinPresentable: Presentable {
    var listener: UserJoinPresentableListener? { get set }
    func showJoinGroupAlert(_ groupId: UUID)
}

protocol UserJoinListener: AnyObject {
    func userJoinDidCloseButtonTap()
    func userJoinDidJoin()
}

protocol UserJoinInteractorDependency{
    var groupApplicationService: GroupApplicationService{ get }
}

final class UserJoinInteractor: PresentableInteractor<UserJoinPresentable>, UserJoinInteractable, UserJoinPresentableListener {

    weak var router: UserJoinRouting?
    weak var listener: UserJoinListener?

    private let dependency: UserJoinInteractorDependency
    private let groupApplicationService: GroupApplicationService
    
    private let userId: UUID
    
    init(
        presenter: UserJoinPresentable,
        dependency: UserJoinInteractorDependency,
        userId: UUID
    ) {
        self.dependency = dependency
        self.groupApplicationService = dependency.groupApplicationService
        self.userId = userId
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        router?.attachGroupList()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func joinGroup(groupId: UUID) {
        Task{ [weak self] in
            guard let self = self else { return }
            
            do{
                let command = JoinGroup(groupId: groupId, memberId: self.userId)
                try await groupApplicationService.when(command)
                await MainActor.run { [weak self] in self?.listener?.userJoinDidJoin() }
            }catch{
                Log.e(error.localizedDescription)
            }            
        }
    }
    
    func closeButtonDidTap() {
        listener?.userJoinDidCloseButtonTap()
    }
    
    func groupListDidSelectRowAt(groupId: UUID) {
        presenter.showJoinGroupAlert(groupId)
    }
    


}
