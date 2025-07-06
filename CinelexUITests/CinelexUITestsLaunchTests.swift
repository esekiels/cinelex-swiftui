//
//  CinelexUITestsLaunchTests.swift
//  CinelexUITests
//
//  Created by Esekiel Surbakti on 06/07/25.
//

import XCTest

final class CinelexUITestsLaunchTests: XCTestCase {

    // swiftlint:disable:next non_overridable_class_declaration static_over_final_class
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
