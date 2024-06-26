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
    private var viewModel: RegistrationViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: RegistrationViewModel = RegistrationViewModel(api: ApiClient())) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    // 这个初始化方法用于从 Storyboard 或 XIB 初始化
    required init?(coder: NSCoder) {                
        self.viewModel = RegistrationViewModel(api: ApiClient())
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDataSource()
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .init(hex: "#f2f2f7")
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
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
        button.setTitleColor(.gray, for: .disabled)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
                
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    
    lazy var spinner: SpinnerViewController = {
        let spinner = SpinnerViewController()
        return spinner
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
    
    @objc func submitButtonTapped() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.showSpinnerView(spinner)
        }
        
        viewModel.submitForm { isSuccess in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.hideSpinnerView(spinner)
                self.showAlert(message: isSuccess ? "Sign Up Success" : "Sign Up Fail")
            }
        }
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
            cell.clickAvatar = { [weak self] in
                guard let self = self else { return }
                self.showPicker()
            }
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
    func bindViewModel() {
        viewModel.$colorSelection
            .map { return ColorUtils.color(from: $0) ?? UIColor.clear }
            .assign(to: \.avatarBorderColor, on: self.viewModel)            
            .store(in: &cancellables)
        
        viewModel.$avatarBorderColor
            .sink { [weak self] color in
                guard let self = self else { return }
                self.updateAvatarBorderColor(color)
            }
            .store(in: &cancellables)
        
        viewModel.$avatarImage
            .sink { [weak self] selectImage in                
                guard let self = self else { return }
                if let image = selectImage {
                    self.updateAvatarImage(image)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$isButtonEnabled
                    .receive(on: RunLoop.main)
                    .assign(to: \.isEnabled, on: signUpButton)
                    .store(in: &cancellables)
        
        Publishers.CombineLatest4(viewModel.$firstName, viewModel.$lastName, viewModel.$email, viewModel.$phoneNumber)
            .map {firstName, lastName , email, phone in
                return !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && !phone.isEmpty
            }
            .assign(to: \.isButtonEnabled, on: self.viewModel)
            .store(in: &cancellables)
    }
    
    private func updateAvatarImage(_ image: UIImage) {
        guard let row = dataSource.snapshot().indexOfItem(.avatar), let section = dataSource.snapshot().indexOfSection(.main) else { return }
        guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as? AvatarTableViewCell else { return }
        cell.updateAvatar(image)
    }
    
    private func updateAvatarBorderColor(_ color: UIColor) {
        // Update avatar border color
        guard let row = dataSource.snapshot().indexOfItem(.avatar), let section = dataSource.snapshot().indexOfSection(.main) else { return }
        guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as? AvatarTableViewCell else { return }
        
        cell.updateBorderColor(color)
    }
}
