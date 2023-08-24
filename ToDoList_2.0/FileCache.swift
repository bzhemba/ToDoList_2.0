//
//  FileCache.swift
//  ToDoList_2.0
//
//  Created by мария баженова on 09.08.2023.
//

import Foundation
import UIKit

class FileCache {
    @Published var toDoList: [TodoItem] = []
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    init() {
        loadFromFile(from: url) { (result: [TodoItem]?) in
            if let result = result {
                self.toDoList = result
            }
        }
    }
    //    func saveToFile() {
    //        do {
    //            let jsonEncoder = JSONEncoder()
    //            let jsonData = try jsonEncoder.encode(ToDoList)
    //            try jsonData.write(to: url)
    //        } catch {
    //            print("Error encoding data: \(error)")
    //        }
    //    }
    //
    //        func loadFromFile() {
    //            do {
    //                let jsonData = try Data(contentsOf: url)
    //                let jsonDecoder = JSONDecoder()
    //                let localItems = try jsonDecoder.decode([TodoItem].self, from: jsonData)
    //                ToDoList = localItems
    //            } catch {
    //                print("Failed to load todos from file: \(error)")
    //            }
    //        }
    //
    //    }
    func saveToFile(to url: URL, queue: DispatchQueue = .global(qos: .utility)) {
        queue.async {
            let jsonEncoder = JSONEncoder()
            if let jsonData = try? jsonEncoder.encode(self.toDoList) {
                DispatchQueue.main.async {
                    try? jsonData.write(to: url)
                }
            }
        }
    }
//    func loadFromFile(from url: URL, queue: DispatchQueue = .global(qos: .utility),
//       completion: @escaping ([TodoItem]?) -> Void) {
//        queue.async {
//            do {
//                let jsonData = try Data(contentsOf: url)
//                let jsonDecoder = JSONDecoder()
//                let data = try jsonDecoder.decode([TodoItem].self, from: jsonData)
//                self.ToDoList = data
//                for todo in self.ToDoList{
//                    if todo.isCompleted == false{
//                        countItems += 1
//                    }
//                }
//
//                DispatchQueue.main.async {
//                    if let listViewController =
//    UIApplication.shared.windows.first(where: { $0.rootViewController?.restorationIdentifier ==
//    "ListViewController" })?.rootViewController
//    as? ListViewController {
//                                       listViewController.tableView.reloadData()
//                                   }
//
//                }
//            } catch {
//                print("Failed to load data from file: \(error)")
//                DispatchQueue.main.async {
//                    completion(nil)
//                }
//            }
//        }
//    }
    func loadFromFile(from url: URL, queue: DispatchQueue = .global(qos: .utility),
                      completion: @escaping ([TodoItem]?) -> Void) {
        queue.async {
            do {
                let jsonData = try Data(contentsOf: url)
                let jsonDecoder = JSONDecoder()
                let data = try jsonDecoder.decode([TodoItem].self, from: jsonData)
                DispatchQueue.main.async {
                    completion(data)
                }
            } catch {
                print("Failed to load data from file: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }

}
