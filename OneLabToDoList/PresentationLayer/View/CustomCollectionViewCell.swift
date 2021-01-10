//
//  CollectionViewCell.swift
//  OneLabToDoList
//
//  Created by Мирас on 1/6/21.
//

import SnapKit

final class CustomCollectionViewCell: UICollectionViewCell {
    
    var isEditing = false {
        didSet {
            deleteButton.isHidden = !isEditing
        }
    }
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.setTitle("-", for: .normal)
        button.backgroundColor = .red
        button.isHidden = true
        return button
    }()
    
    let categoryName: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayOut()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayOut() {
        configureCategoryName()
        configureDeleteButton()
    }
    
    private func configureCategoryName() {
        contentView.addSubview(categoryName)
        categoryName.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureDeleteButton() {
        contentView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(3)
            $0.left.equalToSuperview().offset(3)
            $0.height.equalTo(30)
            $0.width.equalTo(30)
        }
    }
 
}
