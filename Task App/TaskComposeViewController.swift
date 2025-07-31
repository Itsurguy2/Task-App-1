//
//  TaskComposeViewController.swift
//

import UIKit

class TaskComposeViewController: UIViewController {
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var noteField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var taskToEdit: Task?
    var onComposeTask: ((Task) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardHandling()
        populateFields()
    }
    
    private func setupUI() {
        if taskToEdit != nil {
            title = "Edit Task"
        } else {
            title = "New Task"
        }
        
        // Configure date picker
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
        
        // Configure text fields
        titleField.placeholder = "Task title"
        noteField.placeholder = "Add notes (optional)"
        titleField.becomeFirstResponder()
    }
    
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    private func populateFields() {
        guard let task = taskToEdit else { return }
        
        titleField.text = task.title
        noteField.text = task.note
        datePicker.date = task.dueDate
    }
    
    @IBAction func didTapDone(_ sender: UIBarButtonItem) {
        guard let title = titleField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !title.isEmpty else {
            showAlert(title: "Missing Title", message: "Please enter a title for your task.")
            return
        }
        
        let note = noteField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let noteToSave = (note?.isEmpty ?? true) ? nil : note
        
        var task: Task
        if let existingTask = taskToEdit {
            task = existingTask
            task.title = title
            task.note = noteToSave
            task.dueDate = datePicker.date
        } else {
            task = Task(title: title, note: noteToSave, dueDate: datePicker.date)
        }
        
        onComposeTask?(task)
        dismiss(animated: true)
    }
    
    @IBAction func didTapCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
