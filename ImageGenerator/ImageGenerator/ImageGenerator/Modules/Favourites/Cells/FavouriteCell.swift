//
//  FavouriteCell.swift
//  ImageGenerator
//
//  Created by Pavel Boltromyuk on 21.05.23.
//

import UIKit

final class FavouriteCell: UITableViewCell {

    static let identifier = "favouriteCellIdentifier"

    @IBOutlet private weak var requestLabel: UILabel!
    @IBOutlet private weak var favouriteImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        favouriteImage.layer.cornerRadius = 10
    }

    func configure(imageData: Data, request: String) {
        requestLabel.text = request
        favouriteImage.image = UIImage(data: imageData)
    }

}
