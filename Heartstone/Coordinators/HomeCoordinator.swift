//
//  HomeCoordinator.swift
//  Heartstone
//
//  Created by Grigory Avdyushin on 04/07/2019.
//  Copyright © 2019 Grigory Avdyushin. All rights reserved.
//

import UIKit

/// Home (Cards List) Coordinator
class HomeCoordinator<T: Dependency>: Coordinator<T>, RootViewProvider {

    lazy var rootViewController: UIViewController = {
        return navigationViewController
    }()

    private(set) lazy var navigationViewController = UINavigationController()
    private(set) lazy var loadingViewController = LoadingViewController(nibName: nil, bundle: nil)
    private(set) lazy var errorViewController = ErrorViewController(nibName: nil, bundle: nil)

    private let title = NSLocalizedString("Cards", comment: "Cards")

    override func start() {
        super.start()

        navigationViewController.viewControllers = [loadingViewController]
        loadingViewController.title = title

        dependency.dataProvider.fetchCardsList { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.processResults(result)
            }
        }
    }

    fileprivate func processResults(_ result: DataProvider.FetchCardsResult) {
        guard case .success(let cards) = result, cards.isEmpty == false else {
            errorViewController.title = title
            navigationViewController.viewControllers = [errorViewController]
            debugPrint(result)
            return
        }

        debugPrint("Loaded \(cards.count) cards")

        let cardsViewController =  CardsCollectionViewController(
            viewModel: CardListViewModel(cards: cards),
            layout: UICollectionViewFlowLayout()
        )
        cardsViewController.title = title
        cardsViewController.delegate = self
        navigationViewController.viewControllers = [cardsViewController]
    }
}

extension HomeCoordinator: CardCollectionScreenDelegate {

    func didSelectCardInfo(_ cardInfo: CardMinimumDetails) {
        let detailsCoordinator = DetailsCoordinator(
            dependency: dependency,
            navigation: navigationViewController,
            cardInfo: cardInfo
        )
        detailsCoordinator.delegate = self
        add(childCoordinator: detailsCoordinator)
        detailsCoordinator.start()
    }
}

extension HomeCoordinator: DetailsDelegate {

    func onDetailsFlowFinished<T>(_ coordinator: Coordinator<T>) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
