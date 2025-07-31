import UIKit

class TaskCell: UITableViewCell {
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    var onCompleteButtonTapped: ((Task) -> Void)?
    private var task: Task!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        completeButton?.setImage(UIImage(systemName: "circle"), for: .normal)
        completeButton?.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        completeButton?.tintColor = .systemBlue

        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        noteLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        noteLabel?.textColor = .secondaryLabel
        dueDateLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        dueDateLabel?.textColor = .tertiaryLabel
    }

    
    func configure(with task: Task, onCompleteButtonTapped: ((Task) -> Void)?) {
        self.task = task
        self.onCompleteButtonTapped = onCompleteButtonTapped
        updateUI()
    }
    
    private func updateUI() {
        titleLabel.text = task.title
        noteLabel.text = task.note
        noteLabel.isHidden = task.note?.isEmpty ?? true
        
        // Format due date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
       // dueDateLabel.text = "Due: \(formatter.string(from: task.dueDate))"
        
        // Update completion state
        completeButton.isSelected = task.isComplete
        titleLabel.textColor = task.isComplete ? .secondaryLabel : .label
        
        // Add strikethrough for completed tasks
        if task.isComplete {
            titleLabel.attributedText = NSAttributedString(
                string: task.title,
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
        } else {
            titleLabel.attributedText = nil
            titleLabel.text = task.title
        }
    }
    
    @IBAction func didTapCompleteButton(_ sender: UIButton) {
        // Ensure we have a valid task
        guard let currentTask = task else { return }
        
        // Create a modified copy of the task and toggle completion using the proper method
        var updatedTask = currentTask
        updatedTask.toggleCompletion() // This properly handles both isComplete and completedDate
        
        // Add visual feedback - animate the button
        UIView.animate(withDuration: 0.1, animations: {
            self.completeButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.completeButton.transform = CGAffineTransform.identity
            }
        }
        
        // Provide haptic feedback
        if updatedTask.isComplete {
            // Provide haptic feedback for completion
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        } else {
            // Provide lighter haptic feedback for unchecking
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        }
        
        // Update the local task reference
        self.task = updatedTask
        updateUI()
        
        // Pass the updated task to the closure
        onCompleteButtonTapped?(updatedTask)
    }
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {}
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {}
    
    


    
}
