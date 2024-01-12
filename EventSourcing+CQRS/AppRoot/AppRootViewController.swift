//
//  AppRootViewController.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import ModernRIBs
import UIKit

protocol AppRootPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class AppRootViewController: UITabBarController, AppRootPresentable, AppRootViewControllable {

    weak var listener: AppRootPresentableListener?
    
    func setViewControllers(_ viewControllers: [ViewControllable]) {
        
        tabBar.isHidden = false
        view.backgroundColor = .clear
        
        super.setViewControllers(viewControllers.map(\.uiviewController), animated: false)
    }
}
