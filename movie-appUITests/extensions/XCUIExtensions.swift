//
//  XCUIExtensions.swift
//  movie-app
//
//  Created by David Karacs on 2025. 06. 17..
//
import XCTest

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
    
    func firstCellInScrollViewVeiw(withIdentifier id: String) -> XCUIElement {
        return scrollViews[id].firstMatch.cells.element(boundBy: 0)
    }
    
    
    
//    func indexOfImage()
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
