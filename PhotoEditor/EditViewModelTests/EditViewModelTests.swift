//
//  EditViewModelTests.swift
//  EditViewModelTests
//
//  Created by BrinyPiny on 19.07.2023.
//

import XCTest
@testable import PhotoEditor

final class EditViewModelTests: XCTestCase {
    
    var sut: EditViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = EditViewModel(image: UIImage(systemName: "sun.max.fill")!, imageEditingIsDone: { _ in })
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testChangePickedEffectWithNumberLessThanZero() {
        sut.changePickedEffect(with: -10)
        
        XCTAssertTrue(sut.currentPickedEffectSetting == sut.effectSettings[0].effectType)
    }
    
    func testChangePickedEffectWithNumberMoreThanArrayIncludes() {
        sut.changePickedEffect(with: 90000)
        
        XCTAssertTrue(sut.currentPickedEffectSetting == sut.effectSettings[sut.effectSettings.count-1].effectType)
    }
    
    func testChangePickedEffectWithNumberThatArrayContains() {
        sut.changePickedEffect(with: 2)
        
        XCTAssertTrue(sut.currentPickedEffectSetting == sut.effectSettings[2].effectType)
    }
}
