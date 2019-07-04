//
//  CardsCollectionViewController.swift
//  Heartstone
//
//  Created by Grigory Avdyushin on 04/07/2019.
//  Copyright © 2019 Grigory Avdyushin. All rights reserved.
//

import UIKit

class CardsCollectionViewController: BaseCollectionViewController {

    private let viewModel: CardListViewModel

    init(viewModel: CardListViewModel, layout: UICollectionViewLayout) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configureCell(_ cell: CardViewCell, at indexPath: IndexPath) {
        let card = viewModel.cards[indexPath.row]
        cell.viewModel = CardViewModel(
            name: card.name,
            imageURL: card.imageURL,
            borderSides: BorderLayer.Side.border(at: indexPath)
        )
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cards.count
    }
}
