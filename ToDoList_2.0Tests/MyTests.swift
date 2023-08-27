//
//  MyTests.swift
//  ToDoList_2.0Tests
//
//  Created by мария баженова on 27.08.2023.
//

import XCTest
@testable import ToDoList_2_0

final class MyTests: XCTestCase {

    var systemUnderTest: TodoItem!
    override func setUpWithError() throws {
            try super.setUpWithError()
            // в данном методе, который запускается перед началом тестов, инициируем объект в виде класа, что позволит нам обращаться к его свойствам и методам
        systemUnderTest = TodoItem(id: "newItem", text: "n", deadline: nil, importance: .high)
        }

        override func tearDownWithError() throws {
            // убираем объект из памяти после окончания теста, освобождая память для запуска следующих тестов
            systemUnderTest = nil
            try super.tearDownWithError()
        }

        // метод самого теста
        func testExample() throws {
            let ind = 1
            let txt = "?"
            let imp: Importance = .low
            fileCache.toDoList[1] = systemUnderTest
            changeItem(atInd: ind, text: txt, importance: imp)
            // проверяем корректность использования ингридиентов для готовки двух кружек кофе
            // на примере молока, сравниваем использованное количество молока с тем, которое реально должно было израсходоваться
            XCTAssertEqual(fileCache.toDoList[1].text, "?")

        }

        // метод тестирования скорости выполнения определённого блока кода
        func testPerformanceExample() throws {
      //
        }

}
