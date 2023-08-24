import UIKit

enum Importance: String, Codable {
    case high
    case medium
    case low
}
struct TodoItem: Codable {
    let id: String
    let text: String
    let importance: Importance
    let deadline: String?
    var isCompleted: Bool
    init(id: String = UUID().uuidString, text: String = "", deadline: String? = nil, importance: Importance, isCompleted: Bool = false) {
        self.id = id
        self.text = text
        self.deadline = deadline
        self.importance = importance
        self.isCompleted = isCompleted
    }

}

let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let url = documentsDirectory.appendingPathComponent("itemsData.json")
let fileCache = FileCache()
var countItems = 0
func addTodoItem(text: String, importance: Importance, deadline: String? = nil, isCompleted: Bool = false) {
    let newItem = TodoItem(text: text, deadline: deadline, importance: importance, isCompleted: isCompleted)
    fileCache.toDoList.append(newItem)
    fileCache.saveToFile(to: url)
}

func removeItem(at index: Int) {
    fileCache.toDoList.remove(at: index)
    fileCache.saveToFile(to: url)

}

func changeState(at item: Int) -> Bool {
    fileCache.toDoList[item].isCompleted = !(fileCache.toDoList[item].isCompleted)
    fileCache.saveToFile(to: url)
    return fileCache.toDoList[item].isCompleted
}

func changeItem(at: Int, text: String, importance: Importance, deadline: String? = nil) {
    let newItem = TodoItem(text: text, deadline: deadline, importance: importance)
    fileCache.toDoList[at] = newItem
    fileCache.saveToFile(to: url)
}

func moveItem(fromIndex: Int, toIndex: Int) {
    let from = fileCache.toDoList[fromIndex]
    fileCache.toDoList.remove(at: fromIndex)
    fileCache.toDoList.insert(from, at: toIndex)
    fileCache.saveToFile(to: url)
}
