import UIKit

final class TaskListCell: UITableViewCell {
    
    static let identifier = "TaskListCell"
    
    var onCheckboxTapped: (() -> Void)?
    
    // MARK: - UI Elements
    
    private let checkboxButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: DesignSystem.Layout.checkboxSize)
        let image = UIImage(systemName: "circle", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .appSecondary
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: DesignSystem.FontSize.body, weight: .medium)
        label.textColor = .appPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: DesignSystem.FontSize.small)
        label.textColor = .appSecondary
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: DesignSystem.FontSize.small)
        label.textColor = .appSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = DesignSystem.Layout.stackSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - DateFormatter
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = DesignSystem.DateFormat.display
        return formatter
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        checkboxButton.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        onCheckboxTapped = nil
        
        titleLabel.attributedText = nil
        titleLabel.text = nil
        titleLabel.textColor = .appPrimary
        descriptionLabel.text = nil
        dateLabel.text = nil
        
        let config = UIImage.SymbolConfiguration(pointSize: DesignSystem.Layout.checkboxSize)
        let image = UIImage(systemName: "circle", withConfiguration: config)
        checkboxButton.setImage(image, for: .normal)
        checkboxButton.tintColor = .appSecondary
    }
    
    // MARK: - Actions
    
    @objc private func checkBoxTapped() {
        onCheckboxTapped?()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(descriptionLabel)
        textStackView.addArrangedSubview(dateLabel)
        
        contentView.addSubview(checkboxButton)
        contentView.addSubview(textStackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            checkboxButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DesignSystem.Spacing.medium),
            checkboxButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkboxButton.widthAnchor.constraint(equalToConstant: DesignSystem.Layout.checkboxSize),
            checkboxButton.heightAnchor.constraint(equalToConstant: DesignSystem.Layout.checkboxSize),
            
            textStackView.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: DesignSystem.Layout.cellElementSpacing),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DesignSystem.Spacing.medium),
            textStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DesignSystem.Layout.cellVerticalPadding),
            textStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DesignSystem.Layout.cellVerticalPadding)
        ])
    }
    
    // MARK: - Configure
    
    func configure(with task: ToDoTask) {
        dateLabel.text = TaskListCell.dateFormatter.string(from: task.createdAt)
        descriptionLabel.text = task.description
        configureCompletionState(isCompleted: task.isCompleted, title: task.title)
    }
    
    private func configureCompletionState(isCompleted: Bool, title: String) {
        let config = UIImage.SymbolConfiguration(pointSize: 24)
        
        if isCompleted {
            let image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: config)
            checkboxButton.setImage(image, for: .normal)
            checkboxButton.tintColor = .appTint
            
            let attributedString = NSAttributedString(
                string: title,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.appSecondary
                ]
            )
            titleLabel.attributedText = attributedString
            
        } else {
            let image = UIImage(systemName: "circle", withConfiguration: config)
            checkboxButton.setImage(image, for: .normal)
            checkboxButton.tintColor = .appSecondary
            
            titleLabel.attributedText = nil
            titleLabel.text = title
            titleLabel.textColor = .appPrimary
        }
    }
}
