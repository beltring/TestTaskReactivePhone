//
//  ImageGeneratorUITests.swift
//  ImageGeneratorUITests
//
//  Created by Pavel Boltromyuk on 22.05.23.
//

import XCTest

var app: XCUIApplication!

final class ImageGeneratorUITests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testGenerateButton() {
        app.textFields["Text"].tap()
        let textTextField = app.textFields["Text"]
        textTextField.typeText("test127878733")
        app/*@START_MENU_TOKEN@*/.staticTexts["Generate"]/*[[".buttons[\"Generate\"].staticTexts[\"Generate\"]",".staticTexts[\"Generate\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        XCTAssert(!app.alerts.element.exists)

        let imageView = app.images["GeneralImageView"]
        XCTAssertNotNil(imageView)

    }
}
