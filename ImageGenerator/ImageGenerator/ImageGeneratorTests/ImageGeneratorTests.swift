//
//  ImageGeneratorTests.swift
//  ImageGeneratorTests
//
//  Created by Pavel Boltromyuk on 22.05.23.
//

import XCTest
@testable import ImageGenerator

var sut: NetworkManager!

final class ImageGeneratorTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NetworkManager.shared
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testGeneratedImage() throws {
        let promise = expectation(description: "The picture is generated")

        sut.generateImageRequest(text: "test124") { response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if response?.imageData != nil {
                promise.fulfill()
            } else {
                XCTFail("Error: The picture is not generated")
            }
        }

        wait(for: [promise], timeout: 5)
    }
}
