//
//  GroupListViewController.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import ModernRIBs
import UIKit

protocol GroupListPresentableListener: AnyObject {
    func didSelectRowAt(groupId: UUID)
}

final class GroupListViewController: UIViewController, GroupListPresentable, GroupListViewControllable {

    weak var listener: GroupListPresentableListener?
    
    private var dataSource: UITableViewDiffableDataSource<Section, GroupListViewModel>!
    
    private enum Section: CaseIterable{
        case group
    }
        
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setBoldFont(style: .headline)
        label.textColor = .label
        label.text = "GroupList"
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.register(cellType: GroupListCell.self)
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
    
    func setGroups(_ viewModels: [GroupListViewModel]) {
        if dataSource == nil{
            setDataSource()
        }
        
        var snapShot = self.dataSource.snapshot()
        let beforeItems = snapShot.itemIdentifiers(inSection: .group)
        snapShot.deleteItems(beforeItems)
        snapShot.appendItems(viewModels , toSection: .group)
        self.dataSource.apply( snapShot , animatingDifferences: false)
    }
    
    private func setDataSource(){
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, viewModel in
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: GroupListCell.self)
            cell.bindView(viewModel)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, GroupListViewModel>()
        snapshot.appendSections(Section.allCases)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}


extension GroupListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let groupId = dataSource.itemIdentifier(for: indexPath)?.id{
            listener?.didSelectRowAt(groupId: groupId)
        }
    }
}

