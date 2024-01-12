//
//  AppRootRouter.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import ModernRIBs

protocol AppRootInteractable: Interactable, HomeListener, ProfileListener {
    var router: AppRootRouting? { get set }
    var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable {
    func setViewControllers(_ viewControllers: [ViewControllable])
}

final class AppRootRouter: LaunchRouter<AppRootInteractable, AppRootViewControllable>, AppRootRouting {

    private let homeBuildable: HomeBuildable
    private var homeRouting: ViewableRouting?
    
    private let profileBuildable: ProfileBuildable
    private var profileRouting: ViewableRouting?
    
    init(
        interactor: AppRootInteractable,
        viewController: AppRootViewControllable,
        homeBuildable: HomeBuildable,
        profileBuildable: ProfileBuildable
    ) {
        self.homeBuildable = homeBuildable
        self.profileBuildable = profileBuildable
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachTabs() {
        let homeRouting = homeBuildable.build(withListener: interactor)
        let profileRouting = profileBuildable.build(withListener: interactor)
        
        attachChild(homeRouting)
        attachChild(profileRouting)
        
        let routineHome = NavigationControllerable(root: homeRouting.viewControllable)
        let timerHome = NavigationControllerable(root: profileRouting.viewControllable)
                    
        let viewControllers = [
            routineHome,
            timerHome,
        ]
        
        routineHome.setLargeTitle()
        
        viewController.setViewControllers(viewControllers)
    }
}
