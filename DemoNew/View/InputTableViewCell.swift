//
//  InputTableViewCell.swift
//  DemoNew
//
//  Created by 吴伟 on 6/3/24.
//

import UIKit
import SnapKit

class InputTableViewCell: UITableViewCell {
    
    let customLayer = CALayer()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        // Configure the custom layer
        customLayer.cornerRadius = 8
        customLayer.borderColor = UIColor.black.cgColor
        customLayer.borderWidth = 1.0
        customLayer.backgroundColor = UIColor.white.cgColor
        
        // Add custom layer to content view's layer
        contentView.layer.addSublayer(customLayer)
        
        contentView.addSubview(textField)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.bottom.equalToSuperview().inset(28)
            make.right.lessThanOrEqualTo(textField.snp.left).offset(-8)
        }
        textField.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(8)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update custom layer frame to match content view's bounds
        customLayer.frame = contentView.bounds.insetBy(dx: 8, dy: 8)
    }
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Please input"
        textField.textAlignment = .right
        textField.autocapitalizationType = .none
        return textField
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        return label
    }()
}
