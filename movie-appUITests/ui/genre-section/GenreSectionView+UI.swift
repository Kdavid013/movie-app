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
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func ttestBasicUsage() throws {
        // UI tests must launch the application that they test.
        

        app.images["search"].tap()
        app.images["favorites"].tap()
        app.images["settings"].tap()
        app.images["genre"].tap()
        
        
    }
    
    func testUsage() throws {
        // UI tests must launch the application that they test.
        
        let collectionViewsQuery = XCUIApplication().collectionViews
        
        collectionViewsQuery.children(matching: .cell).element(boundBy: 0).children(matching: .other).element(boundBy: 0).children(matching: .other).element.swipeUp()
        
        let collectionView = app.firstCellInCollectionView(withIdentifier: "testCollectionView")
        collectionView.swipeUp()
        
        let adventureGenreCell = app.findElement(withId: "Adventure")
        adventureGenreCell?.tap()
                
        
    }
}

extension XCUIElement {
    var firstChildCell: XCUIElement {
        return self.cells.element(boundBy: 0)
    }

    var firstChildImage: XCUIElement {
        return self.images.element(boundBy: 0)
    }
}

extension XCUIApplication {
    func firstCellInCollectionView(withIdentifier id: String) -> XCUIElement {
        return collectionViews[id].cells.element(boundBy: 0)
    }
}

extension XCUIApplication {
    func findElement(withId id: String) -> XCUIElement? {
        // Ellenőrzésre használt összes ismert típus
        let types: [XCUIElement.ElementType] = [
            .staticText,
            .button,
            .image,
            .textField,
            .secureTextField,
            .switch,
            .navigationBar,
            .collectionView,
            .table,
            .cell,
            .other
        ]

        for type in types {
            let element = descendants(matching: type)[id]
            if element.exists {
                return element
            }
        }

        // Ha semmit nem talált, visszatér egy nem létező elemre
        return nil
    }
}
