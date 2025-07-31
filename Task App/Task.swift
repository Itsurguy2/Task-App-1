//
//  Task.swift
//

import UIKit

// MARK: - Task Model
struct Task: Codable {
    var title: String
    var note: String?
    var dueDate: Date
    var isComplete: Bool = false
    private(set) var completedDate: Date?
    private(set) var createdDate: Date = Date()
    private(set) var id: String = UUID().uuidString
    
    init(title: String, note: String? = nil, dueDate: Date = Date()) {
        self.title = title
        self.note = note
        self.dueDate = dueDate
    }
    
    // Handle completion state changes
    mutating func toggleCompletion() {
        isComplete.toggle()
        completedDate = isComplete ? Date() : nil
    }
}

// MARK: - Task + UserDefaults
extension Task {
    private static let tasksKey = "SavedTasks"
    
    static func save(_ tasks: [Task]) {
        do {
            let data = try JSONEncoder().encode(tasks)
            UserDefaults.standard.set(data, forKey: tasksKey)
        } catch {
            print("Failed to save tasks: \(error)")
        }
    }
    
    static func getTasks() -> [Task] {
        guard let data = UserDefaults.standard.data(forKey: tasksKey) else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([Task].self, from: data)
        } catch {
            print("Failed to load tasks: \(error)")
            return []
        }
    }
    
    func save() {
        var tasks = Task.getTasks()
        
        if let index = tasks.firstIndex(where: { $0.id == self.id }) {
            tasks[index] = self
        } else {
            tasks.append(self)
        }
        
        Task.save(tasks)
    }
    
    func delete() {
        var tasks = Task.getTasks()
        tasks.removeAll { $0.id == self.id }
        Task.save(tasks)
    }
}
