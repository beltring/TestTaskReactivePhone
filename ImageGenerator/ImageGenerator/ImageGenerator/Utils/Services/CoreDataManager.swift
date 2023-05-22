//
//  CoreDataManager.swift
//  ImageGenerator
//
//  Created by Pavel Boltromyuk on 21.05.23.
//

import CoreData
import UIKit

final class CoreDataManager {
    static let shared = CoreDataManager()

    private let objectContext = ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext)!
    private let maxFavouriteItems = 5

    private init() {}

    func addFavouriteImage(imageData: Data, requestString: String) {
        let favouriteImage = FavouriteImage(context: objectContext)
        favouriteImage.data = imageData
        favouriteImage.request = requestString
        favouriteImage.createdDate = Date()
        favouriteImage.text = requestString.components(separatedBy: "=").last
        let images = getFavouriteImages()
        if images.count > maxFavouriteItems {
            let minDate = images.compactMap { $0.createdDate }.min()
            let image = images.first { $0.createdDate == minDate }
            deleteFavouriteImage(favouriteImage: image)
        }
        saveContext()
    }

    func getFavouriteImages() -> [FavouriteImage] {
        let fetchFavouriteImagesRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavouriteImage")

        if let favouriteImages = try? objectContext.fetch(fetchFavouriteImagesRequest) as? [FavouriteImage] {
            return favouriteImages
        }

        return []
    }

    func getFavouriteImage(text: String) -> FavouriteImage? {
        let fetchRequest: NSFetchRequest<FavouriteImage>
        fetchRequest = FavouriteImage.fetchRequest()

        fetchRequest.predicate = NSPredicate(
            format: "text = %@", text
        )

        let objects = try? objectContext.fetch(fetchRequest)
        let favouriteImage = objects?.first

        return favouriteImage
    }

    func deleteFavouriteImage(favouriteImage: FavouriteImage?) {
        guard let favouriteImage = favouriteImage else {
            return
        }
        objectContext.delete(favouriteImage)
        saveContext()
    }

    func addGeneratedImage(imageData: Data, requestString: String) {
        let generatedImage = GeneratedImage(context: objectContext)
        generatedImage.data = imageData
        generatedImage.text = requestString.components(separatedBy: "=").last
        generatedImage.request = requestString
        saveContext()
    }

    func getGeneratedImage(text: String) -> GeneratedImage? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GeneratedImage")
        fetchRequest.predicate = NSPredicate(format: "text = %@", text)
        let objects = try? objectContext.fetch(fetchRequest) as? [GeneratedImage]
        let generatedImage = objects?.first

        return generatedImage
    }

    private func saveContext () {
        guard objectContext.hasChanges else { return }
        do {
            try objectContext.save()
        } catch {
            objectContext.rollback()
        }
    }
}
