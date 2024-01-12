//
//  AddGroupInteractor.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation
import ModernRIBs

protocol AddGroupRouting: ViewableRouting {
    func attachUserList()
}

protocol AddGroupPresentable: Presentable {
    var listener: AddGroupPresentableListener? { get set }
    func showAddGroupAlert(_ userId: UUID)
}

protocol AddGroupListener: AnyObject {
    func addGroupCloseButtonDidTap()
    func addGroupDidAddGroup()
}

protocol AddGroupInteractorDependency{
    var groupApplicationService: GroupApplicationService{ get }
    var groupRepository: GroupRepository{ get }
}

final class AddGroupInteractor: PresentableInteractor<AddGroupPresentable>, AddGroupInteractable, AddGroupPresentableListener {

    weak var router: AddGroupRouting?
    weak var listener: AddGroupListener?

    private let dependency: AddGroupInteractorDependency
    private let groupApplicationService: GroupApplicationService
    private let groupRepository: GroupRepository
    
    
    init(
        presenter: AddGroupPresentable,
        dependency: AddGroupInteractorDependency
    ) {
        self.dependency = dependency
        self.groupApplicationService = dependency.groupApplicationService
        self.groupRepository = dependency.groupRepository
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        router?.attachUserList()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func userListDidSelectRowAt(userId: UUID) {
        presenter.showAddGroupAlert(userId)
    }
    
    
    func addGroup(userId: UUID, groupName: String) {
        let command = CreateGroup(ownerId: userId, groupName: groupName)
        
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                try await groupApplicationService.when(command)
                try await groupRepository.fetchGroups()
                await MainActor.run { [weak self] in self?.listener?.addGroupDidAddGroup() }
            }catch{
                Log.d(error.localizedDescription)
            }
        }
    }
    
    // MARK: Listener
    func closeButtonDidTap() {
        listener?.addGroupCloseButtonDidTap()
    }
    

}
