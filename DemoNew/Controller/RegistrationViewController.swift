//
//  RegistrationViewController.swift
//  DemoNew
//
//  Created by 吴伟 on 6/3/24.
//

import UIKit
import SnapKit
import PhotosUI
import Combine

// Main ViewController for the registration form
class RegistrationViewController: UIViewController {
    private var tableView: UITableView!
    private var dataSource: UITableViewDiffableDataSource<Section, Item>!
    private let viewModel = RegistrationViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDataSource()
        bindViewModel()
    }
    
    private func setupUI() {
        tableView = UITableView(frame: .zero, style: .grouped)
        view.addSubview(tableView)
        view.addSubview(signUpButton)
        tableView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(signUpButton.snp.top).offset(-16)
        }
        signUpButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
    }
    
    private func setupDataSource() {
        tableView.register(InputTableViewCell.self, forCellReuseIdentifier: "InputTableViewCell")
        tableView.register(AvatarTableViewCell.self, forCellReuseIdentifier: "AvatarTableViewCell")
        tableView.register(SelectTableViewCell.self, forCellReuseIdentifier: "SelectTableViewCell")
        
        dataSource = UITableViewDiffableDataSource<Section, Item>(tableView: tableView) { [weak self] (tableView, indexPath, item) in
            guard let self = self else { return UITableViewCell.init(frame: .zero) }
            switch item {
                case .avatar:
                return self.setupAvatarCell(tableView: tableView, indexPath: indexPath, data: "Avatar")
                case .firstName:
                return self.setupInputCell(tableView: tableView, indexPath: indexPath, data: "First Name", item: item)
                case .lastName:
                return self.setupInputCell(tableView: tableView, indexPath: indexPath, data: "Last Name", item: item)
                    
                case .phone:
                return self.setupInputCell(tableView: tableView, indexPath: indexPath, data: "Phone Number", item: item)
                case .email:
                    return self.setupInputCell(tableView: tableView, indexPath: indexPath, data: "Email", item: item)
                case .selectColor:
                return self.setupSelectCell(tableView: tableView, indexPath: indexPath, data: "Custom Avatar Color")
            }
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems([.avatar, .firstName, .lastName, .phone, .email, .selectColor], toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
                
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
}

extension RegistrationViewController {
    func showPicker() {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func buttonTapped() {
        print("Button tapped!")
    }
    
    private func showColorActionSheet() {
        let colorOptions: [String: UIColor] = ["red": .red, "yellow": .yellow, "purple": .purple]
        let actionSheet = UIAlertController(title: "Select Border Color", message: nil, preferredStyle: .actionSheet)
        
        for (colorName, _) in colorOptions {
            let action = UIAlertAction(title: colorName.capitalized, style: .default) { [weak self] _ in
                self?.viewModel.colorSelection = colorName
            }
            actionSheet.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
}

extension RegistrationViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let result = results.first else { return }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            DispatchQueue.main.async {
                self?.viewModel.avatarImage = image as? UIImage
            }
        }
    }
}

extension RegistrationViewController {
    private func setupInputCell(tableView: UITableView, indexPath: IndexPath, data: String, item: Item) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "InputTableViewCell", for: indexPath) as? InputTableViewCell {
            cell.titleLabel.text = data
            switch item {
            case .firstName:
                cell.textField.textPublisher
                    .receive(on: RunLoop.main)
                    .assign(to: \.firstName, on: self.viewModel)
                    .store(in: &cancellables)
            case .lastName:
                cell.textField.textPublisher
                    .receive(on: RunLoop.main)
                    .assign(to: \.lastName, on: self.viewModel)
                    .store(in: &cancellables)
            case .email:
                cell.textField.textPublisher
                    .receive(on: RunLoop.main)
                    .assign(to: \.email, on: self.viewModel)
                    .store(in: &cancellables)
            case .phone:
                cell.textField.textPublisher
                    .receive(on: RunLoop.main)
                    .assign(to: \.phoneNumber, on: self.viewModel)
                    .store(in: &cancellables)
            default:
                break
            }
            cell.selectionStyle = .none
            return cell
        } else {
            return UITableViewCell.init(frame: .zero)
        }
    }
    
    private func setupAvatarCell(tableView: UITableView, indexPath: IndexPath, data: String) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AvatarTableViewCell", for: indexPath) as? AvatarTableViewCell {
            cell.titleLabel.text = data
            cell.selectionStyle = .none
            return cell
        } else {
            return UITableViewCell.init(frame: .zero)
        }
    }
    
    private func setupSelectCell(tableView: UITableView, indexPath: IndexPath, data: String) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SelectTableViewCell", for: indexPath) as? SelectTableViewCell {
            cell.titleLabel.text = data
            cell.clickButton = { [weak self] in
                guard let self = self else { return }
                self.showColorActionSheet()
            }
            cell.selectionStyle = .none
            return cell
        } else {
            return UITableViewCell.init(frame: .zero)
        }
    }
}

extension RegistrationViewController {
    private func bindViewModel() {
        viewModel.$firstName
            .sink { print("First Name: \($0)") }
            .store(in: &cancellables)
        
        viewModel.$lastName
            .sink { print("Last Name: \($0)") }
            .store(in: &cancellables)
        
        viewModel.$email
            .sink { print("Email: \($0)") }
            .store(in: &cancellables)
        
        viewModel.$phoneNumber
            .sink { print("PhoneNumber: \($0)") }
            .store(in: &cancellables)
        
        viewModel.$colorSelection
            .map { return ColorUtils.color(from: $0) ?? UIColor.clear }
            .assign(to: \.avatarBorderColor, on: self.viewModel)            
            .store(in: &cancellables)
        
        viewModel.$avatarBorderColor
            .sink { [weak self] color in
                // Update UI with new border color
                self?.updateAvatarBorderColor(color)
            }
            .store(in: &cancellables)
    }
    
    private func updateAvatarBorderColor(_ color: UIColor) {
        // Update avatar border color
        guard let row = dataSource.snapshot().indexOfItem(.avatar), let section = dataSource.snapshot().indexOfSection(.main) else { return }
        guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as? AvatarTableViewCell else { return }
        
        cell.updateBorderColor(color)
    }
}
