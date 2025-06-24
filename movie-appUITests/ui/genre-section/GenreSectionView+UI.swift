//
//  GenreSectionView+UI.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 22..
//

import XCTest

final class GenreSectionViewUITests: XCTestCase {
    
//    alkalmazás elérése
    let app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
//        érdemes elinditani az alkalmazást
        app.launch()
        sleep(5)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testBasicUsage() throws {
        // UI tests must launch the application that they test.
        

        app.images["searchtab"].tap()
        app.images["favorites"].tap()
        app.images["settings"].tap()
        app.images["genre"].tap()
        
        
    }
//    
    func testGenreSelection() throws {
        // UI tests must launch the application that they test.
//                
        
        let collectionView = app.firstCellInCollectionView(withIdentifier: AccessibilityLabels.genreSectionCollectionView)
        collectionView.swipeUp()
        
        let adventureGenreCell = app.findElement(withId: "Adventure")
        adventureGenreCell?.tap()
        
    }
}

