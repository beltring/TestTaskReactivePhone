//
//  FavouritesViewController.swift
//  ImageGenerator
//
//  Created by Pavel Boltromyuk on 21.05.23.
//

import UIKit

class FavouritesViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var favouritesTableView: UITableView!

    private var favourites = CoreDataManager.shared.getFavouriteImages()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        favourites = CoreDataManager.shared.getFavouriteImages()
        favouritesTableView.reloadData()
    }

    // MARK: - SetupUI

    private func setupTableView() {
        favouritesTableView.delegate = self
        favouritesTableView.dataSource = self
        favouritesTableView.tableFooterView = UIView()
    }
}

// MARK: - UITableViewDataSource&UITableViewDelegate

extension FavouritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favourites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let favourite = favourites[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteCell.identifier) as? FavouriteCell,
              let imageData = favourite.data,
              let request = favourite.request else {
            return UITableViewCell()
        }

        cell.selectionStyle = .none
        cell.configure(imageData: imageData, request: request)

        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let favoriteImage = favourites[indexPath.row]
            CoreDataManager.shared.deleteFavouriteImage(favouriteImage: favoriteImage)
            favourites = CoreDataManager.shared.getFavouriteImages()
            favouritesTableView.reloadData()
        }
    }
}
