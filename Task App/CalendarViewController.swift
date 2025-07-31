//
//  CalendarViewController.swift
//

import UIKit

class CalendarViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    
    private var tasks: [Task] = []
    private var groupedTasks: [(Date, [Task])] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshTasks()
    }
    
    private func setupUI() {
        title = "By Date"
        emptyStateLabel.text = "No tasks scheduled"
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.textColor = .secondaryLabel
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func refreshTasks() {
        tasks = Task.getTasks()
        groupTasksByDate()
        emptyStateLabel.isHidden = !groupedTasks.isEmpty
        tableView.reloadData()
    }
    
    private func groupTasksByDate() {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: tasks) { task in
            calendar.startOfDay(for: task.dueDate)
        }
        
        groupedTasks = grouped.sorted { $0.key < $1.key }.map { (key, value) in
            let sortedTasks = value.sorted { lhs, rhs in
                if lhs.isComplete != rhs.isComplete {
                    return !lhs.isComplete
                }
                return lhs.dueDate < rhs.dueDate
            }
            return (key, sortedTasks)
        }
    }
}

// MARK: - CalendarViewController Extensions
extension CalendarViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupedTasks.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedTasks[section].1.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = groupedTasks[section].0
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today - \(formatter.string(from: date))"
        } else if calendar.isDateInTomorrow(date) {
            return "Tomorrow - \(formatter.string(from: date))"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday - \(formatter.string(from: date))"
        } else {
            return formatter.string(from: date)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        let task = groupedTasks[indexPath.section].1[indexPath.row]
        
        cell.configure(with: task) { [weak self] updatedTask in
            updatedTask.save()
            self?.refreshTasks()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Get the selected task for potential editing
        let selectedTask = groupedTasks[indexPath.section].1[indexPath.row]
        
        // For now, we'll just print the selection
        // You could add navigation to edit screen here if needed
        print("Selected task from calendar view: \(selectedTask.title)")
        
        // Optional: Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
}
