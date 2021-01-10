//
//  TableViewCell.swift
//  OneLabToDoList
//
//  Created by Мирас on 1/8/21.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    var taskLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    let doneImageVIew: UIImageView = {
        var imageView = UIImageView()
        imageView.image = Constants.Images.doneImage
        imageView.isHidden = true
        return imageView
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 2
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayOut()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func configureLayOut() {
        configureContainerView()
        configureDoneImage()
        configureTaskLabel()
    }
    
    private func configureContainerView() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
    }
    
    private func configureTaskLabel() {
        containerView.addSubview(taskLabel)
        taskLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(doneImageVIew.snp.left).offset(-10)
            $0.left.equalToSuperview().offset(10)
        }
    }
    
    private func configureDoneImage() {
        containerView.addSubview(doneImageVIew)
        doneImageVIew.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(30)
            $0.width.equalTo(30)
        }
    }
    
}
