//
//  HomeViewController.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import ModernRIBs
import UIKit

protocol HomePresentableListener: AnyObject {
    func addBarButtonTap()
    func addUserActionTap()
    func addGroupActionTap()
    
    func addUser(userName: String)
}

final class HomeViewController: UIViewController, HomePresentable, HomeViewControllable {
    
    weak var listener: HomePresentableListener?
    
    private lazy var addBarButtonItem : UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle"),
            style: .plain,
            target: self,
            action: #selector(addBarButtonTap)
        )
        return barButtonItem
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0
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
        navigationItem.title = "Home"
        
        tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "checkmark.seal"),
            selectedImage: UIImage(systemName: "checkmark.seal.fill")
        )
        
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = addBarButtonItem
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    //MARK: ViewControllable
    func setUserList(_ view: ViewControllable) {
        let vc = view.uiviewController
        addChild(vc)
        stackView.addArrangedSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    func setGroupList(_ view: ViewControllable) {
        let vc = view.uiviewController
        addChild(vc)
        stackView.addArrangedSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    //MARK: Presentable
    func showAddAlert() {
        showAlert(
            title: "Add User & Member",
            message: "Chooose  User or Group",
            actions: [
                AlertAction(title: "Group", type: 0),
                AlertAction(title: "User", type: 1)
            ]) { [weak self] output in
                guard let self = self else { return }
                if output.index == 1{
                    listener?.addUserActionTap()
                    return
                }
                
                listener?.addGroupActionTap()
            }
    }
    
    func showAddUserAlert() {
        showAlert(
            title: "Add User",
            message: "Enter the user name you want to add",
            actions: [
                AlertAction(type:0, textField: inputTextFeild()),
                AlertAction(title: "Cancle", type:1, style: .cancel),
                AlertAction(title: "Add",type:2),
            ]) { [weak self] output in
                if output.index != 2{ return }
                
                guard let self = self,
                let userName = output.textFields?.first?.text else { return }
                listener?.addUser(userName: userName)
            }
    }
    
    
    //MARK: Private
    private func inputTextFeild() -> UITextField{
        let textField = UITextField()
        textField.setFont(style: .caption2)
        textField.textColor = .label
        textField.placeholder = "Give user's name"
        return textField
    }
    
    
    @objc
    private func addBarButtonTap(){
        listener?.addBarButtonTap()
    }
}
