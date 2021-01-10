//
//  ViewController.swift
//  OneLabToDoList
//
//  Created by Мирас on 1/6/21.
//

import SnapKit

class HomePageVC: UIViewController {
    
    private let viewModel = HomePageViewModel()
    private let tasksPageVC = TasksPageVC()
    
    private lazy var categoriesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "id")
        collectionView.backgroundColor = Constants.Colors.mainColor
        return collectionView
    }()
    
    private let flowLayout: UICollectionViewFlowLayout = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.minimumLineSpacing = 20
        collectionViewFlowLayout.minimumInteritemSpacing = 0
        return collectionViewFlowLayout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.mainColor
        viewModel.fetchCategories()
        configureLayOut()
    }
    
    private func configureLayOut() {
        configureNavController()
        configureCollectionView()
    }
    
    private func configureNavController() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Arial", size: 30)!]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add,
                                                            target: self,
                                                            action: #selector(addCategoryButtonDidPress))
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.title = "Categories"
    }
    
    private func configureCollectionView() {
        view.addSubview(categoriesCollectionView)
        categoriesCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.left.equalToSuperview().offset(40)
            $0.right.equalToSuperview().offset(-40)
            $0.bottom.equalToSuperview().offset(-100)
        }
    }
    
    @objc private func addCategoryButtonDidPress() {
        print(categoriesCollectionView.numberOfItems(inSection: 0))
        let alert = UIAlertController(title: "Create new category",
                                      message: nil,
                                      preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter catergory name"
        }
        let doneAction = UIAlertAction(title: "Done", style: .default) { (action) in
            self.viewModel.createNewCategory(name: alert.textFields![0].text!)
            self.categoriesCollectionView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(doneAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        categoriesCollectionView.indexPathsForVisibleItems.forEach { (indexPath) in
            let cell = categoriesCollectionView.cellForItem(at: indexPath) as! CustomCollectionViewCell
            cell.isEditing = editing
        }
    }
}

extension HomePageVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! CustomCollectionViewCell
        cell.categoryName.text = viewModel.categoryArray[indexPath.row].name
        cell.layer.cornerRadius = 20
        cell.backgroundColor = .white
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonDidPress), for: .touchUpInside)
        cell.deleteButton.tag = indexPath.row
        cell.isEditing = isEditing
        return cell
    }
    
    @objc private func deleteButtonDidPress(_ sender: UIButton!) {
        self.viewModel.removeCategories(at: sender.tag)
        self.categoriesCollectionView.reloadData()
    }
}

extension HomePageVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isEditing {
            tasksPageVC.selectedCategory = viewModel.categoryArray[indexPath.row]
            navigationController?.pushViewController(tasksPageVC, animated: true)
        } else {
            let alert = UIAlertController(title: "Rename category",
                                          message: nil,
                                          preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.text = self.viewModel.categoryArray[indexPath.row].name
            }
            let doneAction = UIAlertAction(title: "Done", style: .default) { (action) in
                self.viewModel.updateCategoryName(at: indexPath.row, with: alert.textFields![0].text!)
                self.categoriesCollectionView.reloadData()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(doneAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: viewModel.calculateWidth(screen: Double(UIScreen.main.bounds.width)), height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
