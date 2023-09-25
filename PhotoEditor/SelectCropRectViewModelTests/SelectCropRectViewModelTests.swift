//
//  SelectCropRectViewModelTests.swift
//  SelectCropRectViewModelTests
//
//  Created by BrinyPiny on 18.07.2023.
//

import XCTest
@testable import PhotoEditor

final class SelectCropRectViewModelTests: XCTestCase {
    
    var sut: SelectCropRectViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = SelectCropRectViewModel()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    /// Тест проверяет правильно ли высчитывается сдвиг длины стороны если она вмещается в родительскую длину стороны
    func testIfRectFits() {
        var currentRectTranslation: Double = 0
        let maxSideSize: CGFloat = 2000
        let rectSideSize: CGFloat = 300
        let translation: CGFloat = 20
        let rectCoordinatePosition: CGFloat = 0
        
        sut.applyResizeRectTranslation(rectTranslation: &currentRectTranslation, maxSideSize: maxSideSize, rectSideSize: rectSideSize, translation: translation, rectCoordinatePosition: rectCoordinatePosition)
        
        XCTAssertEqual(currentRectTranslation, translation)
    }
    
    /// Тест проверяет правильно ли высчитывается сдвиг длины стороны если она менее 50 поинтов.
    func testRectSideSizeLessThan50() {
        var currentRectTranslation: Double = 0
        let maxSideSize: CGFloat = 2000
        let rectSideSize: CGFloat = 20
        let translation: CGFloat = 10
        let rectCoordinatePosition: CGFloat = 0
        
        sut.applyResizeRectTranslation(rectTranslation: &currentRectTranslation, maxSideSize: maxSideSize, rectSideSize: rectSideSize, translation: translation, rectCoordinatePosition: rectCoordinatePosition)
        
        XCTAssertTrue(rectSideSize + currentRectTranslation == 50)
    }
    
    /// Тест проверяет правильно ли высчитывается сдвиг длины стороны если она имеет сдвиг по одной из координат и не вмещается в родительский прямоугольник
    func testRectSideSizeIfItNotFitInParentRect() {
        var currentRectTranslation: Double = 0
        let maxSideSize: CGFloat = 2000
        let rectSideSize: CGFloat = 2000
        let translation: CGFloat = 10
        let rectCoordinatePosition: CGFloat = 50
        
        sut.applyResizeRectTranslation(rectTranslation: &currentRectTranslation, maxSideSize: maxSideSize, rectSideSize: rectSideSize, translation: translation, rectCoordinatePosition: rectCoordinatePosition)
        
        XCTAssertEqual(currentRectTranslation + rectSideSize + rectCoordinatePosition, maxSideSize)
    }
    
    /// Тест проверяет правильно ли высчитывается сдвиг координаты если она вмещается в родительский прямоугольник
    func testRectPositionCoordinateIfItFitsInParentRect() {
        var currentRectTranslation: Double = 0
        let rectCoordinatePosition: CGFloat = 20
        let translation: CGFloat = 50
        let rectSideSize: CGFloat = 1000
        let maxSideSize: CGFloat = 2000
        
        sut.applyPositionRectTranslation(rectTranslation: &currentRectTranslation, rectCoordinatePosition: rectCoordinatePosition, translation: translation, rectSideSize: rectSideSize, maxSideSize: maxSideSize)
        
        XCTAssertTrue(currentRectTranslation == translation)
    }
    
    /// Тест проверяет правильно ли высчитывается сдвиг координаты если он меньше нуля и не вмещается в родительский прямоугольник
    func testRectPositionCoordinateLessThanZero() {
        var currentRectTranslation: Double = 0
        let rectCoordinatePosition: CGFloat = 50
        let translation: CGFloat = -90
        let rectSideSize: CGFloat = 1000
        let maxSideSize: CGFloat = 2000
        
        sut.applyPositionRectTranslation(rectTranslation: &currentRectTranslation, rectCoordinatePosition: rectCoordinatePosition, translation: translation, rectSideSize: rectSideSize, maxSideSize: maxSideSize)
        
        XCTAssertTrue(currentRectTranslation == -rectCoordinatePosition)
    }
    
    /// Тест проверяет правильно ли высчитывается сдвиг координаты если он больше чем длина стороны родительского прямоугольника
    func testRectPositionCoordinateMoreThanMaxParentRectSize() {
        var currentRectTranslation: Double = 0
        let rectCoordinatePosition: CGFloat = 500
        let translation: CGFloat = 700
        let rectSideSize: CGFloat = 1000
        let maxSideSize: CGFloat = 2000
        
        sut.applyPositionRectTranslation(rectTranslation: &currentRectTranslation, rectCoordinatePosition: rectCoordinatePosition, translation: translation, rectSideSize: rectSideSize, maxSideSize: maxSideSize)
        
        XCTAssertEqual(currentRectTranslation + rectSideSize + rectCoordinatePosition, maxSideSize)
    }
    
    /// Проверка правильности высчитывания прямоугольника для фотографии
    func testCalculatingRectForCroppingImage() {
        sut.defaultRectSize = CGSize(width: 640, height: 360)
        sut.rectX = 100
        sut.rectY = 50
        sut.rectHeight = 200
        sut.rectWidth = 400
        
        var cgRect = CGRect()
        
        let imageSize = CGSize(width: 1920, height: 1080)
        
        sut.calculateNewRect(rect: &cgRect, imageSize: imageSize)
        
        XCTAssertTrue(cgRect.width == (imageSize.width / sut.defaultRectSize.width) * sut.rectWidth)
        XCTAssertTrue(cgRect.height == (imageSize.height / sut.defaultRectSize.height) * sut.rectHeight)
        XCTAssertTrue(cgRect.origin.x == sut.rectX * (imageSize.width / sut.defaultRectSize.width))
        XCTAssertTrue(cgRect.origin.y == (sut.defaultRectSize.height - sut.rectY) * (imageSize.height / sut.defaultRectSize.height) - ((imageSize.height / sut.defaultRectSize.height) * sut.rectHeight))
    }
}
