//
//  UserListViewController.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import ModernRIBs
import UIKit

protocol UserListPresentableListener: AnyObject {
    func didSelectRowAt(userId: UUID)
}

final class UserListViewController: UIViewController, UserListPresentable, UserListViewControllable {

    weak var listener: UserListPresentableListener?
    
    private var dataSource: UITableViewDiffableDataSource<Section, UserListViewModel>!
    
    private enum Section: CaseIterable{
        case user
    }
        
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setBoldFont(style: .headline)
        label.textColor = .label
        label.text = "UserList"
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.register(cellType: UserListCell.self)
        tableView.separatorStyle = .singleLine
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        return tableView
    }()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setLayout()
    }
    
    
    private func setLayout(){
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        
        let inset: CGFloat = 16.0
                
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func setUsers(_ viewModels: [UserListViewModel]) {
        if dataSource == nil{
            setDataSource()
        }
        
        var snapShot = self.dataSource.snapshot()
        let beforeItems = snapShot.itemIdentifiers(inSection: .user)
        snapShot.deleteItems(beforeItems)
        snapShot.appendItems(viewModels , toSection: .user)
        self.dataSource.apply( snapShot , animatingDifferences: false)
    }
    
    private func setDataSource(){
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, viewModel in
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UserListCell.self)
            cell.bindView(viewModel)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, UserListViewModel>()
        snapshot.appendSections(Section.allCases)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}


extension UserListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let userId = dataSource.itemIdentifier(for: indexPath)?.id{
            listener?.didSelectRowAt(userId: userId)
        }
    }
}
