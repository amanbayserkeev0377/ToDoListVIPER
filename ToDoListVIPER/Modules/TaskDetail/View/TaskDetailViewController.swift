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
        static let topPadding: CGFloat = 20
        static let spacing: CGFloat = 16
    }
    
    // MARK: - Properties
    
    var presenter: TaskDetailPresenterProtocol?
    
    // MARK: - UI
    
    private let titleTextField: UITextField = {
        let field = UITextField()
        field.placeholder = Appearance.titlePlaceHolder
        field.font = .systemFont(ofSize: Appearance.titleFontSize, weight: .bold)
        field.textColor = .appPrimary
        field.borderStyle = .none
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
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
        textView.textColor = .appPrimary
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.didSaveTask(
            title: titleTextField.text ?? "",
            description: descriptionTextView.text ?? ""
        )
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .appBackground
        view.addSubview(titleTextField)
        view.addSubview(dateLabel)
        view.addSubview(descriptionTextView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Appearance.topPadding),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Appearance.sidePadding),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Appearance.sidePadding),
            
            dateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Appearance.sidePadding),
            
            descriptionTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Appearance.spacing),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Appearance.sidePadding),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Appearance.sidePadding),
            descriptionTextView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - TaskDetailViewProtocol

extension TaskDetailViewController: TaskDetailViewProtocol {
    
    func showTask(_ task: ToDoTask) {
        titleTextField.text = task.title
        descriptionTextView.text = task.description
        
        let formatter = DateFormatter()
        formatter.dateFormat = Appearance.dateFormat
        dateLabel.text = formatter.string(from: task.createdAt)
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
