//
//  TasksPageVC.swift
//  OneLabToDoList
//
//  Created by Мирас on 1/7/21.
//

import UIKit

class TasksPageVC: UIViewController {
    
    let viewModel = TasksPageViewModel()
    
    var selectedCategory: Category? {
        didSet{
            viewModel.fetchTasks(from: selectedCategory!)
            tableView.reloadData()
        }
    }
    
    private let tableView: UITableView = {
        let tableVC = UITableView()
        tableVC.separatorStyle = .none
        tableVC.register(CustomTableViewCell.self, forCellReuseIdentifier: String(describing: CustomTableViewCell.self))
        tableVC.rowHeight = 100
        tableVC.backgroundColor = Constants.Colors.mainColor
        return tableVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        configureNavController()
        configureTableViewController()
    }
    
    private func configureNavController() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskButtonDidPress))
    }
    
    
    private func configureTableViewController() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc private func addTaskButtonDidPress() {
        let alert = UIAlertController(title: "Create new task",
                                      message: nil,
                                      preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter task name"
        }
        let doneAction = UIAlertAction(title: "Done", style: .default) { (action) in
            self.viewModel.createNewTask(title: alert.textFields![0].text!, category: self.selectedCategory!)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(doneAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

extension TasksPageVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.taskStatusDidChange(at: indexPath.row)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, boolValue) in
            self.viewModel.removeTasks(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            let alert = UIAlertController(title: "Undo deletion",
                                          message: "Are you sure you want to delete the task?",
                                          preferredStyle: .alert)
            
            let undoAction = UIAlertAction(title: "Undo", style: .default) { (action) in
                self.viewModel.undoTaskDelition()
                tableView.reloadData()
            }
            let cancelAction = UIAlertAction(title: "Yes", style: .cancel, handler: nil)
            
            alert.addAction(undoAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            self.viewModel.didEndTimer = {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, boolValue) in
            let alert = UIAlertController(title: "Rename task",
                                          message: nil,
                                          preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.text = self.viewModel.items[indexPath.row].title
            }
            let doneAction = UIAlertAction(title: "Done", style: .default) { (action) in
                self.viewModel.updateTask(at: indexPath.row, with: alert.textFields![0].text!)
                self.tableView.reloadData()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(doneAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return swipeAction
    }
    
}

extension TasksPageVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomTableViewCell.self),
                                                 for: indexPath) as! CustomTableViewCell
        
        cell.textLabel?.text = viewModel.items[indexPath.row].title
        cell.textLabel!.textColor = viewModel.getTextColor(for: indexPath.row)
        
        cell.backgroundColor = Constants.Colors.mainColor
        cell.doneImageVIew.isHidden = !viewModel.items[indexPath.row].done
        return cell
    }
}
