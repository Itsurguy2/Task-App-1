//
//  TaskListViewController.swift
//

import UIKit

// MARK: - Design System
struct AppDesign {
    
    // MARK: - Color Palette
    struct Colors {
        // Primary Colors - Modern Blue Gradient
        static let primaryBlue = UIColor(red: 0.24, green: 0.52, blue: 1.0, alpha: 1.0) // #3D85FF
        static let primaryBlueLight = UIColor(red: 0.35, green: 0.63, blue: 1.0, alpha: 1.0) // #59A0FF
        static let primaryBlueDark = UIColor(red: 0.18, green: 0.41, blue: 0.89, alpha: 1.0) // #2E69E3
        
        // Secondary Colors - Elegant Purple
        static let secondaryPurple = UIColor(red: 0.46, green: 0.35, blue: 1.0, alpha: 1.0) // #7659FF
        static let secondaryPurpleLight = UIColor(red: 0.57, green: 0.46, blue: 1.0, alpha: 1.0) // #9275FF
        
        // Success Colors - Fresh Green
        static let successGreen = UIColor(red: 0.2, green: 0.78, blue: 0.35, alpha: 1.0) // #33C759
        static let successGreenLight = UIColor(red: 0.3, green: 0.85, blue: 0.45, alpha: 1.0) // #4DD972
        
        // Warning/Accent Colors - Vibrant Orange
        static let accentOrange = UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 1.0) // #FF9500
        static let accentOrangeLight = UIColor(red: 1.0, green: 0.69, blue: 0.25, alpha: 1.0) // #FFB040
        
        // Neutral Colors - Modern Grays
        static let backgroundPrimary = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.05, green: 0.05, blue: 0.07, alpha: 1.0) // #0D0D12
                : UIColor(red: 0.98, green: 0.98, blue: 1.0, alpha: 1.0) // #FAFAFF
        }
        
        static let backgroundSecondary = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.08, green: 0.08, blue: 0.12, alpha: 1.0) // #14141F
                : UIColor(red: 0.95, green: 0.95, blue: 0.98, alpha: 1.0) // #F2F2FA
        }
        
        static let cardBackground = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.11, green: 0.11, blue: 0.15, alpha: 1.0) // #1C1C26
                : UIColor.white
        }
        
        static let textPrimary = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0) // #F2F2F7
                : UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0) // #1C1C1F
        }
        
        static let textSecondary = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.68, green: 0.68, blue: 0.70, alpha: 1.0) // #AEAEB2
                : UIColor(red: 0.43, green: 0.43, blue: 0.45, alpha: 1.0) // #6E6E73
        }
        
        static let borderColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.19, green: 0.19, blue: 0.23, alpha: 1.0) // #30303B
                : UIColor(red: 0.88, green: 0.88, blue: 0.91, alpha: 1.0) // #E1E1E8
        }
    }
    
    // MARK: - Typography
    struct Typography {
        static let largeTitle = UIFont.systemFont(ofSize: 34, weight: .bold)
        static let title1 = UIFont.systemFont(ofSize: 28, weight: .bold)
        static let title2 = UIFont.systemFont(ofSize: 22, weight: .bold)
        static let title3 = UIFont.systemFont(ofSize: 20, weight: .semibold)
        static let headline = UIFont.systemFont(ofSize: 17, weight: .semibold)
        static let body = UIFont.systemFont(ofSize: 17, weight: .regular)
        static let callout = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let subheadline = UIFont.systemFont(ofSize: 15, weight: .regular)
        static let footnote = UIFont.systemFont(ofSize: 13, weight: .regular)
        static let caption1 = UIFont.systemFont(ofSize: 12, weight: .regular)
        static let caption2 = UIFont.systemFont(ofSize: 11, weight: .regular)
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let tiny: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let extraLarge: CGFloat = 32
        static let huge: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 24
    }
    
    // MARK: - Shadows
    struct Shadow {
        static let light = ShadowStyle(
            color: UIColor.black.withAlphaComponent(0.05),
            offset: CGSize(width: 0, height: 2),
            radius: 4,
            opacity: 1.0
        )
        
        static let medium = ShadowStyle(
            color: UIColor.black.withAlphaComponent(0.1),
            offset: CGSize(width: 0, height: 4),
            radius: 12,
            opacity: 1.0
        )
        
        static let heavy = ShadowStyle(
            color: UIColor.black.withAlphaComponent(0.15),
            offset: CGSize(width: 0, height: 8),
            radius: 24,
            opacity: 1.0
        )
    }
    
    struct ShadowStyle {
        let color: UIColor
        let offset: CGSize
        let radius: CGFloat
        let opacity: Float
    }
}

// MARK: - Enhanced Task Cell
class EnhancedTaskCell: UITableViewCell {
    
    // MARK: - UI Elements
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let noteLabel = UILabel()
    private let dueDateLabel = UILabel()
    private let completeButton = UIButton()
    private let priorityIndicator = UIView()
    private let dateIcon = UIImageView()
    private let noteIcon = UIImageView()
    
    // MARK: - Properties
    private var task: Task?
    private var onCompleteButtonTapped: ((Task) -> Void)?
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // Configure container view
        containerView.backgroundColor = AppDesign.Colors.cardBackground
        containerView.layer.cornerRadius = AppDesign.CornerRadius.medium
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = AppDesign.Colors.borderColor.cgColor
        applyShadow(to: containerView, style: AppDesign.Shadow.light)
        
        // Configure title label
        titleLabel.font = AppDesign.Typography.headline
        titleLabel.textColor = AppDesign.Colors.textPrimary
        titleLabel.numberOfLines = 2
        
        // Configure note label
        noteLabel.font = AppDesign.Typography.subheadline
        noteLabel.textColor = AppDesign.Colors.textSecondary
        noteLabel.numberOfLines = 1
        
        // Configure due date label
        dueDateLabel.font = AppDesign.Typography.caption1
        dueDateLabel.textColor = AppDesign.Colors.textSecondary
        
        // Configure complete button
        completeButton.layer.cornerRadius = 12
        completeButton.layer.borderWidth = 2
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        
        // Configure priority indicator
        priorityIndicator.layer.cornerRadius = 2
        priorityIndicator.backgroundColor = AppDesign.Colors.accentOrange
        
        // Configure icons
        dateIcon.image = UIImage(systemName: "calendar.badge.clock")
        dateIcon.tintColor = AppDesign.Colors.textSecondary
        dateIcon.contentMode = .scaleAspectFit
        
        noteIcon.image = UIImage(systemName: "note.text")
        noteIcon.tintColor = AppDesign.Colors.textSecondary
        noteIcon.contentMode = .scaleAspectFit
        
        // Add subviews
        contentView.addSubview(containerView)
        containerView.addSubview(completeButton)
        containerView.addSubview(priorityIndicator)
        containerView.addSubview(titleLabel)
        containerView.addSubview(noteLabel)
        containerView.addSubview(noteIcon)
        containerView.addSubview(dueDateLabel)
        containerView.addSubview(dateIcon)
        
        // Disable autoresizing masks
        [containerView, completeButton, priorityIndicator, titleLabel, noteLabel, noteIcon, dueDateLabel, dateIcon].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container view
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AppDesign.Spacing.small),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppDesign.Spacing.medium),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppDesign.Spacing.medium),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppDesign.Spacing.small),
            
            // Complete button
            completeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: AppDesign.Spacing.medium),
            completeButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            completeButton.widthAnchor.constraint(equalToConstant: 24),
            completeButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Priority indicator
            priorityIndicator.leadingAnchor.constraint(equalTo: completeButton.trailingAnchor, constant: AppDesign.Spacing.medium),
            priorityIndicator.topAnchor.constraint(equalTo: containerView.topAnchor, constant: AppDesign.Spacing.medium),
            priorityIndicator.widthAnchor.constraint(equalToConstant: 4),
            priorityIndicator.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -AppDesign.Spacing.medium),
            
            // Title label
            titleLabel.leadingAnchor.constraint(equalTo: priorityIndicator.trailingAnchor, constant: AppDesign.Spacing.medium),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -AppDesign.Spacing.medium),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: AppDesign.Spacing.medium),
            
            // Note icon
            noteIcon.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            noteIcon.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: AppDesign.Spacing.small),
            noteIcon.widthAnchor.constraint(equalToConstant: 14),
            noteIcon.heightAnchor.constraint(equalToConstant: 14),
            
            // Note label
            noteLabel.leadingAnchor.constraint(equalTo: noteIcon.trailingAnchor, constant: AppDesign.Spacing.tiny),
            noteLabel.centerYAnchor.constraint(equalTo: noteIcon.centerYAnchor),
            noteLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            // Date icon
            dateIcon.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateIcon.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: AppDesign.Spacing.small),
            dateIcon.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -AppDesign.Spacing.medium),
            dateIcon.widthAnchor.constraint(equalToConstant: 14),
            dateIcon.heightAnchor.constraint(equalToConstant: 14),
            
            // Due date label
            dueDateLabel.leadingAnchor.constraint(equalTo: dateIcon.trailingAnchor, constant: AppDesign.Spacing.tiny),
            dueDateLabel.centerYAnchor.constraint(equalTo: dateIcon.centerYAnchor),
            dueDateLabel.trailingAnchor.constraint(lessThanOrEqualTo: titleLabel.trailingAnchor),
        ])
    }
    
    // MARK: - Configuration
    func configure(with task: Task, onCompleteButtonTapped: @escaping (Task) -> Void) {
        self.task = task
        self.onCompleteButtonTapped = onCompleteButtonTapped
        
        // Configure title
        titleLabel.text = task.title
        
        // Configure note
        if let note = task.note, !note.isEmpty {
            noteLabel.text = note
            noteLabel.isHidden = false
            noteIcon.isHidden = false
        } else {
            noteLabel.isHidden = true
            noteIcon.isHidden = true
        }
        
        // Configure due date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDateLabel.text = formatter.string(from: task.dueDate)
        
        // Configure completion state
        updateCompletionState()
        
        // Add subtle animation
        animateIn()
    }
    
    private func updateCompletionState() {
        guard let task = task else { return }
        
        if task.isComplete {
            // Completed state
            completeButton.backgroundColor = AppDesign.Colors.successGreen
            completeButton.layer.borderColor = AppDesign.Colors.successGreen.cgColor
            completeButton.setImage(UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)), for: .normal)
            completeButton.tintColor = .white
            
            titleLabel.textColor = AppDesign.Colors.textSecondary
            titleLabel.attributedText = NSAttributedString(
                string: task.title,
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            
            containerView.alpha = 0.7
            priorityIndicator.backgroundColor = AppDesign.Colors.textSecondary
        } else {
            // Incomplete state
            completeButton.backgroundColor = .clear
            completeButton.layer.borderColor = AppDesign.Colors.borderColor.cgColor
            completeButton.setImage(nil, for: .normal)
            
            titleLabel.textColor = AppDesign.Colors.textPrimary
            titleLabel.attributedText = NSAttributedString(string: task.title)
            
            containerView.alpha = 1.0
            priorityIndicator.backgroundColor = AppDesign.Colors.primaryBlue
        }
    }
    
    // MARK: - Actions
    @objc private func completeButtonTapped() {
        guard let task = task else { return }
        
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Animate button press
        UIView.animate(withDuration: 0.1, animations: {
            self.completeButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.completeButton.transform = .identity
            }
        }
        
        // Toggle completion
        var updatedTask = task
        updatedTask.toggleCompletion()
        
        // Update UI with animation
        self.task = updatedTask
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut) {
            self.updateCompletionState()
        }
        
        
    }
    
    // MARK: - Animations
    private func animateIn() {
        transform = CGAffineTransform(translationX: 0, y: 20)
        alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut) {
            self.transform = .identity
            self.alpha = 1
        }
    }
    
    // MARK: - Helper Methods
    private func applyShadow(to view: UIView, style: AppDesign.ShadowStyle) {
        view.layer.shadowColor = style.color.cgColor
        view.layer.shadowOffset = style.offset
        view.layer.shadowRadius = style.radius
        view.layer.shadowOpacity = style.opacity
        view.layer.masksToBounds = false
    }
}

// MARK: - Task List View Controller
class TaskListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    
    var tasks = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Apply professional design
        applyProfessionalDesign()
        
        // Register the enhanced cell
        tableView.register(EnhancedTaskCell.self, forCellReuseIdentifier: "EnhancedTaskCell")

        // Hide top cell separator
        tableView.tableHeaderView = UIView()
        
        // Configure empty state label
        emptyStateLabel.text = "No tasks yet!\nTap + to create your first task"
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.textColor = .secondaryLabel
        emptyStateLabel.numberOfLines = 0

        // Set table view data source
        tableView.dataSource = self
        
        // Configure table view appearance
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120

        // Set table view delegate
        tableView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshTasks()
    }

    @IBAction func didTapNewTaskButton(_ sender: Any) {
        performSegue(withIdentifier: "ComposeSegue", sender: nil)
    }
    
    // Prepare for navigation to the Task Compose View Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Check if this is the compose segue
        guard segue.identifier == "ComposeSegue" else { return }
        
        // Get the navigation controller that contains the compose view controller
        if let composeNavController = segue.destination as? UINavigationController,
           // Verify we can get the top view controller
           let topViewController = composeNavController.topViewController,
           // Get the actual compose view controller
           let composeViewController = topViewController as? TaskComposeViewController {
            
            // Set up the compose view controller
            composeViewController.view.layoutIfNeeded()
            
            // Set the task to edit if one was passed
            composeViewController.taskToEdit = sender as? Task
            
            // Configure the navigation title based on whether we're editing or creating
            if sender as? Task != nil {
                composeViewController.title = "Edit Task"
            } else {
                composeViewController.title = "New Task"
            }
            
            // Set up the completion handler
            composeViewController.onComposeTask = { [weak self] task in
                // Save the new or edited task
                task.save()
                // Refresh the tasks list
                self?.refreshTasks()
            }
        }
    }
    
    // MARK: - Helper Functions
    
    // Configure the empty state display
    private func updateEmptyState() {
        emptyStateLabel.isHidden = !tasks.isEmpty
        tableView.isHidden = tasks.isEmpty
    }
    
    // Refresh all tasks with proper sorting
    private func refreshTasks() {
        
        // Show loading state if needed
        view.isUserInteractionEnabled = false
        
        // 1. Get the current saved tasks
        var tasks = Task.getTasks()
        
        // Validate that we have tasks to work with
        print("Loaded \(tasks.count) tasks from storage")
        
        // 2. Sort the tasks list for the specified conditions
        tasks.sort { lhs, rhs in
            if lhs.isComplete && rhs.isComplete {
                // i. For completed tasks, sort ascending based on completed date
                return lhs.completedDate! < rhs.completedDate!
            } else if !lhs.isComplete && !rhs.isComplete {
                // ii. For incomplete tasks, sort ascending based on created date
                return lhs.createdDate < rhs.createdDate
            } else {
                // iii. Sort incomplete tasks before completed tasks
                return !lhs.isComplete && rhs.isComplete
            }
        }
        
        // Log the sorting results for debugging
        print("Sorted tasks: \(tasks.count) total, \(tasks.filter { !$0.isComplete }.count) incomplete")
        
        // 3. Update the main tasks array
        self.tasks = tasks
        
        // Ensure we're on the main thread for UI updates
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // 4. Hide empty state label if there are tasks
            self.emptyStateLabel.isHidden = !tasks.isEmpty
            
            // Re-enable user interaction
            self.view.isUserInteractionEnabled = true
            
            // 5. Reload the table view with animation
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
}

// MARK: - Table View Data Source Methods
extension TaskListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    // Create and configure cells for each task
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Ensure we have a valid index
        guard indexPath.row < tasks.count else {
            return UITableViewCell()
        }
        
        // Use the new enhanced cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "EnhancedTaskCell", for: indexPath) as! EnhancedTaskCell
        
        // Get the task for the associated row
        let task = tasks[indexPath.row]
        
        // Validate the task data
        print("Configuring cell for task: \(task.title)")
        
        // Configure the cell with completion handler
        cell.configure(with: task, onCompleteButtonTapped: { [weak self] task in
            
            // Add loading indicator if needed
            DispatchQueue.main.async {
                
                // Save the task passed back in the closure
                task.save()
                
                // Provide user feedback
                print("Task completion toggled: \(task.title) - \(task.isComplete)")
                
                // Refresh the tasks list to reflect updates
                self?.refreshTasks()
            }
        })
        
        // Add accessibility support
        cell.accessibilityLabel = "Task: \(task.title)"
        cell.accessibilityHint = task.isComplete ? "Completed task, tap to mark incomplete" : "Incomplete task, tap to mark complete"
        
        // Return the configured cell
        return cell
    }
    
    // Enable swipe to delete functionality
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Ensure we have a valid index
        guard indexPath.row < tasks.count else { return }
        
        // Handle the delete case
        if editingStyle == .delete {
            // Get the task to delete for confirmation
            let taskToDelete = tasks[indexPath.row]
            print("Deleting task: \(taskToDelete.title)")
            
            // Remove the task from the tasks array
            tasks.remove(at: indexPath.row)
            
            // Save the updated tasks array
            Task.save(tasks)
            
            // Update empty state if needed
            if tasks.isEmpty {
                emptyStateLabel.isHidden = false
            }
            
            // Tell the table view to delete the row with animation
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // Provide haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        }
    }
}

// MARK: - Table View Delegate Methods
extension TaskListViewController: UITableViewDelegate {
    
    // Handle row selection for editing tasks
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Ensure we have a valid index
        guard indexPath.row < tasks.count else { return }
        
        // Deselect the row for better UX
        tableView.deselectRow(at: indexPath, animated: false)
        
        // Add visual feedback
        if let cell = tableView.cellForRow(at: indexPath) {
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    cell.transform = CGAffineTransform.identity
                }
            }
        }
        
        // Get the selected task
        let selectedTask = tasks[indexPath.row]
        
        // Log the selection for debugging
        print("Selected task for editing: \(selectedTask.title)")
        
        // Perform segue to edit the task
        performSegue(withIdentifier: "ComposeSegue", sender: selectedTask)
    }
}

// MARK: - Professional Design Extensions
extension TaskListViewController {
    
    func applyProfessionalDesign() {
        // Configure main view
        view.backgroundColor = AppDesign.Colors.backgroundPrimary
        
        // Configure navigation bar
        setupNavigationBarAppearance()
        
        // Configure table view
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        // Add gradient background
        addGradientBackground()
        
        // Configure empty state
        setupEmptyState()
        
        // Add floating action button
        setupFloatingActionButton()
    }
    
    private func setupNavigationBarAppearance() {
        guard let navigationController = navigationController else { return }
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = AppDesign.Colors.backgroundPrimary.withAlphaComponent(0.95)
        appearance.titleTextAttributes = [
            .foregroundColor: AppDesign.Colors.textPrimary,
            .font: AppDesign.Typography.title2
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: AppDesign.Colors.textPrimary,
            .font: AppDesign.Typography.largeTitle
        ]
        
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.tintColor = AppDesign.Colors.primaryBlue
        
        title = "My Tasks"
    }
    
    private func addGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            AppDesign.Colors.backgroundPrimary.cgColor,
            AppDesign.Colors.backgroundSecondary.cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.insertSubview(backgroundView, at: 0)
    }
    
    private func setupEmptyState() {
        // The empty state will be enhanced by the design system colors
        emptyStateLabel.font = AppDesign.Typography.title3
        emptyStateLabel.textColor = AppDesign.Colors.textSecondary
    }
    
    private func setupFloatingActionButton() {
            let fab = UIButton(type: .system)
            fab.backgroundColor = AppDesign.Colors.primaryBlue
            fab.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)), for: .normal)
            fab.tintColor = .white
            fab.layer.cornerRadius = 28
            fab.layer.shadowColor = AppDesign.Colors.primaryBlue.withAlphaComponent(0.4).cgColor
            fab.layer.shadowOffset = CGSize(width: 0, height: 4)
            fab.layer.shadowRadius = 12
            fab.layer.shadowOpacity = 1.0
            
            // Add gradient
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [
                AppDesign.Colors.primaryBlueLight.cgColor,
                AppDesign.Colors.primaryBlue.cgColor
            ]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            gradientLayer.frame = CGRect(x: 0, y: 0, width: 56, height: 56)
            gradientLayer.cornerRadius = 28
            fab.layer.insertSublayer(gradientLayer, at: 0)
            
            fab.addTarget(self, action: #selector(didTapNewTaskButton), for: .touchUpInside)
            
            view.addSubview(fab)
            fab.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                fab.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -AppDesign.Spacing.large),
                fab.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -AppDesign.Spacing.large),
                fab.widthAnchor.constraint(equalToConstant: 56),
                fab.heightAnchor.constraint(equalToConstant: 56)
            ])
            
            // Add press animation
            fab.addTarget(self, action: #selector(fabPressed), for: .touchDown)
            fab.addTarget(self, action: #selector(fabReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        }
        
        @objc private func fabPressed() {
            guard let fab = view.subviews.last as? UIButton else { return }
            UIView.animate(withDuration: 0.1) {
                fab.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
        }
        
        @objc private func fabReleased() {
            guard let fab = view.subviews.last as? UIButton else { return }
            UIView.animate(withDuration: 0.1) {
                fab.transform = .identity
            }
        }
    }
