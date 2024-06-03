//
//  SelectTableViewCell.swift
//  DemoNew
//
//  Created by 吴伟 on 6/3/24.
//


import UIKit
import SnapKit

class SelectTableViewCell: UITableViewCell {
    
    var clickButton: (()->Void)?
    
    let customLayer = CALayer()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Configure the custom layer
        customLayer.cornerRadius = 8
        customLayer.borderColor = UIColor.black.cgColor
        customLayer.borderWidth = 1.0
        
        // Add custom layer to content view's layer
        contentView.layer.addSublayer(customLayer)
        
        contentView.addSubview(selectButton)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            //TODO: 添加right约束
        }
        selectButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        customLayer.frame = contentView.bounds.insetBy(dx: 8, dy: 8)
    }
    
    lazy var selectButton: UIButton = {
        let button = UIButton()
        button.setTitle("Please Select", for: .normal)
        button.setTitleColor(.blue, for: .normal)        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .cyan
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    @objc func buttonTapped() {
        clickButton?()
    }
}
