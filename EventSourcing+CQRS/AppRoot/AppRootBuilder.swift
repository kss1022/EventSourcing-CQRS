//
//  AppRootBuilder.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import ModernRIBs

protocol AppRootDependency: Dependency {
}

// MARK: - Builder
protocol AppRootBuildable: Buildable {
    func build() -> (launchRouter: LaunchRouting, urlHandler: URLHandler)
}

final class AppRootBuilder: Builder<AppRootDependency>, AppRootBuildable {

    override init(dependency: AppRootDependency) {
        super.init(dependency: dependency)
    }

    func build() -> (launchRouter: LaunchRouting, urlHandler: URLHandler) {
        let viewController = AppRootViewController()
        
        let component = AppRootComponent(
            dependency: dependency,
            viewController: viewController
        )
                                
        let interactor = AppRootInteractor(presenter: viewController, dependency: component)
        
        let homeBuilder = HomeBuilder(dependency: component)
        let profileBuiler = ProfileBuilder(dependency: component)
        
        let router = AppRootRouter(
            interactor: interactor,
            viewController: viewController,
            homeBuildable: homeBuilder,
            profileBuildable: profileBuiler
        )
        
        return (router , interactor)
    }
}
