//
//  GroupListInteractor.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation
import ModernRIBs
import Combine

protocol GroupListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol GroupListPresentable: Presentable {
    var listener: GroupListPresentableListener? { get set }
    func setGroups(_ viewModels: [GroupListViewModel])
}

protocol GroupListListener: AnyObject {
    func groupListDidSelectRowAt(groupId: UUID)
}

protocol GroupListInteractorDependency{
    var groupRepository: GroupRepository{ get }
}

final class GroupListInteractor: PresentableInteractor<GroupListPresentable>, GroupListInteractable, GroupListPresentableListener {

    weak var router: GroupListRouting?
    weak var listener: GroupListListener?
        
    private let dependency: GroupListInteractorDependency
    private let groupRepository: GroupRepository
    
    private var cancellables: Set<AnyCancellable>
    
    init(
        presenter: GroupListPresentable,
        dependency: GroupListInteractorDependency
    ) {
        self.dependency = dependency
        self.groupRepository = dependency.groupRepository
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        
        groupRepository.groups
            .receive(on: DispatchQueue.main)
            .sink { groups in
                let viewModels = groups.map(GroupListViewModel.init)
                self.presenter.setGroups(viewModels)
            }
            .store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func didSelectRowAt(groupId: UUID) {
        listener?.groupListDidSelectRowAt(groupId: groupId)
    }
}
