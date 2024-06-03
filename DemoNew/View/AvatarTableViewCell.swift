//
//  AvatarTableViewCell.swift
//  DemoNew
//
//  Created by 吴伟 on 6/3/24.
//

import UIKit
import SnapKit

class AvatarTableViewCell: UITableViewCell {
    
    var clickAvatar: (()->Void)?        
    
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
        
        contentView.addSubview(colorView)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        colorView.snp.makeConstraints { make in
            make.size.equalTo(CGSize.init(width: 88, height: 88))
            make.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(16)
        }
        avatarImageView.snp.makeConstraints { make in
            make.center.equalTo(colorView.snp.center)
            make.size.equalTo(CGSize.init(width: 52, height: 52))
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update custom layer frame to match content view's bounds
        customLayer.frame = contentView.bounds.insetBy(dx: 8, dy: 8)
    }
    
    func bind(color: String) {
        colorView.backgroundColor = UIColor.init(hex: color)
    }
    
    func updateAvatar(_ image: UIImage) {
        avatarImageView.image = image
    }
    
    func updateBorderColor(_ color: UIColor) {
        colorView.backgroundColor = color
    }
    
    lazy var colorView: UIButton = {
        let button = UIButton()
        button.backgroundColor = .init(hex: "#c2c2c2")
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 26
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .init(hex: "#dae8fc")
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    @objc func buttonTapped() {
        clickAvatar?()
    }
}


