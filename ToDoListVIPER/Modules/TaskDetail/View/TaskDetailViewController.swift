import UIKit

final class TaskDetailViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let titlePlaceholder = "Новая задача"
        static let descriptionPlaceholder = "Описание"
    }
    
    // MARK: - Properties
    
    var presenter: TaskDetailPresenterProtocol?
    
    // MARK: - UI
    
    private let titleTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: DesignSystem.FontSize.title, weight: .bold)
        textView.textColor = .appSecondary
        textView.text = Constants.titlePlaceholder
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: DesignSystem.FontSize.small)
        label.textColor = .appSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: DesignSystem.FontSize.body)
        textView.textColor = .appSecondary
        textView.text = Constants.descriptionPlaceholder
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // MARK: - DateFormatter
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = DesignSystem.DateFormat.display
        return formatter
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
        dateLabel.text = TaskDetailViewController.dateFormatter.string(from: Date())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let title = titleTextView.textColor == .appPrimary ? titleTextView.text ?? "" : ""
        let description = descriptionTextView.textColor == .appPrimary ? descriptionTextView.text ?? "" : ""
        presenter?.didSaveTask(title: title, description: description)
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .appBackground
        navigationItem.largeTitleDisplayMode = .never
        setupKeyboardToolbar()
        titleTextView.delegate = self
        descriptionTextView.delegate = self
        view.addSubview(titleTextView)
        view.addSubview(dateLabel)
        view.addSubview(descriptionTextView)
        setupConstraints()
    }
    
    private func setupKeyboardToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.barStyle = .black
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let hideButton = UIBarButtonItem(
            image: UIImage(systemName: DesignSystem.Icon.hideKeyboard),
            style: .plain,
            target: self,
            action: #selector(hideKeyboard)
        )
        hideButton.tintColor = .appTint
        toolbar.items = [flexSpace, hideButton]
        
        titleTextView.inputAccessoryView = toolbar
        descriptionTextView.inputAccessoryView = toolbar
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: DesignSystem.Spacing.small),
            titleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DesignSystem.Spacing.medium),
            titleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DesignSystem.Spacing.medium),
            
            dateLabel.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: DesignSystem.Spacing.small),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DesignSystem.Spacing.medium),
            
            descriptionTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: DesignSystem.Spacing.medium),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DesignSystem.Spacing.medium),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DesignSystem.Spacing.medium),
            descriptionTextView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - TaskDetailViewProtocol

extension TaskDetailViewController: TaskDetailViewProtocol {
    
    func showTask(_ task: ToDoTask) {
        titleTextView.text = task.title
        titleTextView.textColor = .appPrimary
        descriptionTextView.text = task.description.isEmpty ? Constants.descriptionPlaceholder : task.description
        descriptionTextView.textColor = task.description.isEmpty ? .appSecondary : .appPrimary
        dateLabel.text = TaskDetailViewController.dateFormatter.string(from: task.createdAt)
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextViewDelegate

extension TaskDetailViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .appSecondary {
            textView.text = ""
            textView.textColor = .appPrimary
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textView == titleTextView ? Constants.titlePlaceholder : Constants.descriptionPlaceholder
            textView.textColor = .appSecondary
        }
    }
}
