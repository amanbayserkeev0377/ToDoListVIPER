import UIKit

final class TaskDetailViewController: UIViewController {
    
    private enum Appearance {
        static let titlePlaceHolder = "Новая задача"
        static let descriptionPlaceholder = "Описание"
        static let dateFormat = "dd/MM/yy"
        
        static let titleFontSize: CGFloat = 34
        static let descriptionFontSize: CGFloat = 16
        static let dateFontSize: CGFloat = 12
        static let sidePadding: CGFloat = 16
        static let topPadding: CGFloat = 8
        static let spacing: CGFloat = 16
    }
    
    // MARK: - Properties
    
    var presenter: TaskDetailPresenterProtocol?
    
    // MARK: - UI
    
    private let titleTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: Appearance.titleFontSize, weight: .bold)
        textView.textColor = .appSecondary
        textView.text = Appearance.titlePlaceHolder
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Appearance.dateFontSize)
        label.textColor = .appSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: Appearance.descriptionFontSize)
        textView.textColor = .appSecondary
        textView.text = Appearance.descriptionPlaceholder
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
        formatter.dateFormat = Appearance.dateFormat
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
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let hideButton = UIBarButtonItem(
            image: UIImage(systemName: "keyboard.chevron.compact.down"),
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
            titleTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Appearance.topPadding),
            titleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Appearance.sidePadding),
            titleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Appearance.sidePadding),
            
            dateLabel.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Appearance.sidePadding),
            
            descriptionTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Appearance.spacing),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Appearance.sidePadding),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Appearance.sidePadding),
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
        
        descriptionTextView.text = task.description.isEmpty ? Appearance.descriptionPlaceholder : task.description
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
            if textView == titleTextView {
                textView.text = Appearance.titlePlaceHolder
            } else {
                textView.text = Appearance.descriptionPlaceholder
            }
            textView.textColor = .appSecondary
        }
    }
}
