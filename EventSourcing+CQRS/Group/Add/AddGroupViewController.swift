//
//  AddGroupViewController.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import ModernRIBs
import UIKit

protocol AddGroupPresentableListener: AnyObject {
    func addGroup(userId: UUID, groupName: String)
    func closeButtonDidTap()
}

final class AddGroupViewController: UIViewController, AddGroupPresentable, AddGroupViewControllable {


    weak var listener: AddGroupPresentableListener?
    
    private lazy var closeBarButtonItem: UIBarButtonItem = {
        let closebuttonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeBarButtonItemTap))
        return closebuttonItem
    }()
        
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
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
        title = "Choose Group Reader"
        
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = closeBarButtonItem
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: ViewControllable
    func setUserLists(_ view: ViewControllable) {
        let vc = view.uiviewController
        addChild(vc)
        stackView.addArrangedSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    // MARK: Presentbale
    func showAddGroupAlert(_ userId: UUID) {
        showAlert(
            title: "Add Group",
            message: "Enter the group name you want to add",
            actions: [
                AlertAction(type:0, textField: inputTextFeild()),
                AlertAction(title: "Cancle", type:1, style: .cancel),
                AlertAction(title: "Add",type:2),
            ]) { [weak self] output in
                if output.index != 2{ return }
                
                guard let self = self,
                let groupName = output.textFields?.first?.text else { return }
                listener?.addGroup(userId: userId, groupName: groupName)
            }
    }
    
    
    //MARK: Private
    private func inputTextFeild() -> UITextField{
        let textField = UITextField()
        textField.setFont(style: .caption2)
        textField.textColor = .label
        textField.placeholder = "Give group's name"
        return textField
    }
    
    @objc
    private func closeBarButtonItemTap(){
        listener?.closeButtonDidTap()
    }
    
    
}
