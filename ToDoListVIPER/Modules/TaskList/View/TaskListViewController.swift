import UIKit

final class TaskListViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let title = "Задачи"
        static let searchPlaceholder = "Поиск"
    }
    
    // MARK: - Properties
    
    var presenter: TaskListPresenterProtocol?
    private var tasks: [ToDoTask] = []
    
    // MARK: - UI Elements
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.separatorColor = .darkGray
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = Constants.searchPlaceholder
        search.obscuresBackgroundDuringPresentation = false
        return search
    }()
    
    private let bottomBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .appSecondaryBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let taskCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appPrimary
        label.font = .systemFont(ofSize: DesignSystem.FontSize.caption)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: DesignSystem.Layout.checkboxSize)
        let image = UIImage(systemName: DesignSystem.Icon.addTask, withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .appTint
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupSearchController()
        setupActions()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .appBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = Constants.title
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.appPrimary
        ]
        
        view.addSubview(tableView)
        view.addSubview(bottomBarView)
        bottomBarView.addSubview(taskCountLabel)
        bottomBarView.addSubview(addButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomBarView.topAnchor),
            
            bottomBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBarView.heightAnchor.constraint(equalToConstant: DesignSystem.Layout.bottomBarHeight),
            
            taskCountLabel.centerXAnchor.constraint(equalTo: bottomBarView.centerXAnchor),
            taskCountLabel.topAnchor.constraint(equalTo: bottomBarView.topAnchor, constant: DesignSystem.Spacing.medium),
            
            addButton.trailingAnchor.constraint(equalTo: bottomBarView.trailingAnchor, constant: -DesignSystem.Spacing.medium),
            addButton.topAnchor.constraint(equalTo: bottomBarView.topAnchor, constant: DesignSystem.Spacing.small)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskListCell.self, forCellReuseIdentifier: TaskListCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = DesignSystem.Layout.tableRowHeight
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupActions() {
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func addButtonTapped() {
        presenter?.didTapAddTask()
    }
    
    // MARK: - Private Helpers
    
    private func updateTaskCount() {
        taskCountLabel.text = "\(tasks.count) Задач"
    }
}

// MARK: - TaskListViewProtocol

extension TaskListViewController: TaskListViewProtocol {
    
    func showTasks(_ tasks: [ToDoTask]) {
        self.tasks = tasks
        updateTaskCount()
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension TaskListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TaskListCell.identifier,
            for: indexPath
        ) as? TaskListCell else {
            return UITableViewCell()
        }
        
        let task = tasks[indexPath.row]
        cell.configure(with: task)
        
        cell.onCheckboxTapped = { [weak self] in
            guard let self else { return }
            self.presenter?.didToggleTask(task)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TaskListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didTapTask(tasks[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let task = tasks[indexPath.row]
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            
            let editAction = UIAction(
                title: "Редактировать",
                image: UIImage(systemName: DesignSystem.Icon.edit)
            ) { [weak self] _ in
                self?.presenter?.didTapTask(task)
            }
            
            let shareAction = UIAction(
                title: "Поделиться",
                image: UIImage(systemName: DesignSystem.Icon.share)
            ) { [weak self] _ in
                let text = "\(task.title)\n\(task.description)"
                let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
                self?.present(activityVC, animated: true)
            }
            
            let deleteAction = UIAction(
                title: "Удалить",
                image: UIImage(systemName: DesignSystem.Icon.trash),
                attributes: .destructive
            ) { [weak self] _ in
                self?.presenter?.didDeleteTask(task)
            }
            
            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        }
    }
}

// MARK: - UISearchResultsUpdating

extension TaskListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        guard query.isEmpty || query.count >= 2 else { return }
        presenter?.didSearchTasks(with: query)
    }
}
