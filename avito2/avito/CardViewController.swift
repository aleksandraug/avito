//
//  CardViewController.swift
//  avito
//
//  Created by Александра Угольнова on 27.08.2023.
//

import Foundation
import UIKit

class CardViewController: UIViewController{
    
    var viewModel: CardViewModel?
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .gray
        return indicator
    }()
    
    private lazy var labelTitle : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.Title
        label.font = Constants.Fonts.ui20Reg
        return label
    }()
    private lazy var labelPrice : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.Title
        label.font = Constants.Fonts.ui20Semi
        return label
    }()
    private lazy var labelContacts : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.Title
        label.font = Constants.Fonts.ui20Semi
        return label
    }()
    private lazy var labelLocation : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.Title
        label.font = Constants.Fonts.ui16Reg
        return label
    }()
    private lazy var labelTime : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.Title
        label.font = Constants.Fonts.ui16Light
        return label
    }()
    private lazy var labelDesc : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.Title
        label.font = Constants.Fonts.ui20Semi
        return label
    }()
    private lazy var labelDescription : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.Title
        label.font = Constants.Fonts.ui16Reg
        label.numberOfLines = 0
        return label
    }()
    private lazy var labelEmail : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.BLueLink
        label.font = Constants.Fonts.ui16Light
        return label
    }()
    private lazy var labelPhone : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.BLueLink
        label.font = Constants.Fonts.ui16Light
        return label
    }()
    private lazy var dogImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = Constants.Colors.greyLight
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setUpViews()
        setUpConstraints()
        configureUI()
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        
        activityIndicator.startAnimating()
  
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func formatDateString(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "dd MMMM yyyy"
            return dateFormatter.string(from: date)
        }
        
        return ""
    }
    
    func configureUI() {
        if let result = viewModel {
            print("Title: \(result.title)")
            print("Price: \(result.price)")
            print("Location: \(result.location)")
            print("Time: \(result.created_date)")
            
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
                 
            DispatchQueue.global().async {
                      sleep(2)
                      
                      DispatchQueue.main.async {
                          self.labelTitle.text = result.title
                          self.labelPrice.text = result.price
                          self.labelLocation.text = result.location + ", " + result.address
                          self.labelTime.text = "Опубликовано: " + self.formatDateString(result.created_date)
                          let string = result.image_url
                          let url = URL(string: string)
                          self.dogImageView.downloaded(from: url!, contentMode: .scaleAspectFill)
                          self.labelContacts.text = "Контакты"
                          self.labelDesc.text = "Описание"
                          self.labelPhone.text = result.phone_number
                          self.labelEmail.text = result.email
                          self.labelDescription.text = result.description

                          self.activityIndicator.stopAnimating()
                      }
                  }
        }

    }
    
    private func setUpViews(){
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(dogImageView)
        containerView.addSubview(labelTitle)
        containerView.addSubview(labelPrice)
        containerView.addSubview(labelLocation)
        containerView.addSubview(labelTime)
        containerView.addSubview(labelEmail)
        containerView.addSubview(labelPhone)
        containerView.addSubview(labelDescription)
        containerView.addSubview(labelContacts)
        containerView.addSubview(labelDesc)
        containerView.addSubview(activityIndicator)
    }
    
    private func setUpConstraints(){
       // let topInset: CGFloat = 15
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                        
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            dogImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            dogImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dogImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            dogImageView.heightAnchor.constraint(equalToConstant: 300),
               
            labelTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            labelTitle.topAnchor.constraint(equalTo: dogImageView.bottomAnchor, constant: 20),
               
            labelPrice.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor),
            labelPrice.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 8),
               
            labelLocation.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor),
            labelLocation.topAnchor.constraint(equalTo: labelPrice.bottomAnchor, constant: 10),
            
            labelContacts.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor),
            labelContacts.topAnchor.constraint(equalTo: labelLocation.bottomAnchor, constant: 16),
   
            labelEmail.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor),
            labelEmail.topAnchor.constraint(equalTo: labelContacts.bottomAnchor, constant: 8),
            
            labelPhone.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor),
            labelPhone.topAnchor.constraint(equalTo: labelEmail.bottomAnchor, constant: 8),
            
            labelDesc.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor),
            labelDesc.topAnchor.constraint(equalTo: labelPhone.bottomAnchor, constant: 16),
            
            labelDescription.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor),
            labelDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            labelDescription.topAnchor.constraint(equalTo: labelDesc.bottomAnchor, constant: 8),
            
               
            labelTime.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor),
            labelTime.topAnchor.constraint(equalTo: labelDescription.bottomAnchor, constant: 16),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
           ])
     
    }
}
