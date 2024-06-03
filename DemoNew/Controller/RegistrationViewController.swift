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
class RegistrationViewController: UIViewController, PHPickerViewControllerDelegate {
    private var tableView: UITableView!
    private var dataSource: UITableViewDiffableDataSource<Section, Item>!
    private let viewModel = RegistrationViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupDataSource()
        bindViewModel()
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupDataSource() {
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        
        dataSource = UITableViewDiffableDataSource<Section, Item>(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
            switch item {
            case .firstName:
                cell.titleLabel.text = "First Name"
            case .lastName:
                cell.titleLabel.text = "Last Name"
            case .phone:
                cell.titleLabel.text = "Phone"
            case .email:
                cell.titleLabel.text = "Email"
            case .avatar:
                cell.textLabel?.text = "Avatar"                                                
            }
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
            snapshot.appendItems([.firstName, .lastName, .phone, .email, .avatar], toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
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
        
        viewModel.$avatarBorderColor
            .sink { [weak self] color in
                // Update UI with new border color
                self?.updateAvatarBorderColor(color)
            }
            .store(in: &cancellables)
    }
    
    private func updateAvatarBorderColor(_ color: UIColor) {
        // Update avatar border color
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let result = results.first else { return }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            DispatchQueue.main.async {
                self?.viewModel.avatarImage = image as? UIImage
            }
        }
    }
    
    func showPicker() {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
}
