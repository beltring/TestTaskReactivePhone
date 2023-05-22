//
//  GeneralViewController.swift
//  ImageGenerator
//
//  Created by Pavel Boltromyuk on 20.05.23.
//

import UIKit

class GeneralViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var addToFavouriteButton: UIButton!
    @IBOutlet private weak var generatedImageView: UIImageView!
    @IBOutlet private weak var generateButton: UIButton!

    private var responseModel: ImageGeneratorResponse?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    // MARK: - SetupUI

    private func setupUI() {
        addToFavouriteButton.layer.cornerRadius = 8
        generateButton.layer.cornerRadius = 8
        generatedImageView.layer.cornerRadius = 10
    }

    // MARK: - Actions
    
    @IBAction func tappedAddToFavouriteButton(_ sender: Any) {
        let favouritesImage = CoreDataManager.shared.getFavouriteImages()

        guard let responseModel = responseModel,
              !favouritesImage.contains(where: { $0.request == responseModel.request }) else {
            return
        }

        CoreDataManager.shared.addFavouriteImage(imageData: responseModel.imageData,
                                                 requestString: responseModel.request)
    }

    @IBAction func tappedGenerateButton(_ sender: Any) {
        guard let searchText = searchTextField.text else { return }

        if let favouriteImage = CoreDataManager.shared.getGeneratedImage(text: searchText),
           let data = favouriteImage.data {
            generatedImageView.image = UIImage(data: data)
            return
        }

        NetworkManager.shared.generateImageRequest(text: searchText) { [weak self] responseModel, error in
            if let error = error {
                self?.presentAlert(title: "Error", message: error.localizedDescription)
                return
            }

            guard let responseModel = responseModel else {
                return
            }

            self?.responseModel = responseModel
            CoreDataManager.shared.addGeneratedImage(imageData: responseModel.imageData, requestString: responseModel.request)
            DispatchQueue.main.async {
                self?.generatedImageView.image = UIImage(data: responseModel.imageData)
            }
        }
    }
}
