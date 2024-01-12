//
//  GroupUsersInteractor.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/12/24.
//

import Foundation
import ModernRIBs
import Combine

protocol GroupUsersRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol GroupUsersPresentable: Presentable {
    var listener: GroupUsersPresentableListener? { get set }
    func setGroup(groupName: String, ownerName: String)
    func setGroupUsers(_ viewModels: [GroupUserListViewModel])
}

protocol GroupUsersListener: AnyObject {
    func groupUserCloseButtonDidtap()
}

protocol GroupUsersInteractorDependency{
    var groupRepository: GroupRepository{ get }
}

final class GroupUsersInteractor: PresentableInteractor<GroupUsersPresentable>, GroupUsersInteractable, GroupUsersPresentableListener {

    weak var router: GroupUsersRouting?
    weak var listener: GroupUsersListener?
    
    private let dependency: GroupUsersInteractorDependency
    private let groupRepository: GroupRepository
    
    private var cancelllables: Set<AnyCancellable>
    
    private let groupId: UUID
    
    init(
        presenter: GroupUsersPresentable,
        dependency: GroupUsersInteractorDependency,
        groupId: UUID
    ) {
        self.dependency = dependency
        self.groupRepository = dependency.groupRepository
        self.cancelllables = .init()
        self.groupId = groupId
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                try await groupRepository.fetchGroupUsers(groupId: groupId)
            }catch{
                Log.e(error.localizedDescription)
            }
        }
        
        groupRepository.groups.map{
            $0.first { $0.id == self.groupId }
        }
        .compactMap{ $0 }
        .sink { group in
            let groupName = group.name      
            let ownername = group.ownderName
            self.presenter.setGroup(groupName: groupName, ownerName: ownername)
        }
        .store(in: &cancelllables)
            
        
        
        
        groupRepository.groupUsers
            .receive(on: DispatchQueue.main)
            .filter{
                $0.isEmpty ||  $0.first?.groupId == self.groupId
            }
            .sink { groupUsers in                
                let viewModels = groupUsers.map(GroupUserListViewModel.init)
                self.presenter.setGroupUsers(viewModels)
            }
            .store(in: &cancelllables)
            
        
    }

    override func willResignActive() {
        super.willResignActive()
        self.cancelllables.forEach { $0.cancel() }
        self.cancelllables.removeAll()
    }
    
    func closeButtonDidTap() {
        listener?.groupUserCloseButtonDidtap()
    }
    

}
