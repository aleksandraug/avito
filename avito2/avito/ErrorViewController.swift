//
//  ErrorViewController.swift
//  avito
//
//  Created by Александра Угольнова on 29.08.2023.
//

import Foundation
import UIKit

class ErrorViewController: UIViewController{
    
    private lazy var errorLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = Constants.Colors.Title
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 18)
            label.numberOfLines = 0
            return label
        }()
    
    func setErrorText(_ text: String) {
            errorLabel.text = text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(errorLabel)
        setUpConstraints()
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
  
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpConstraints(){
        
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    

    
}




