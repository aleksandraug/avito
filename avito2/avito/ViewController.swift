//
//  ViewController.swift
//  avito
//
//  Created by Александра Угольнова on 27.08.2023.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    var data: [CellViewModel] = []
    var isLoadingDetails: Bool = false
    
    struct ResponseData: Codable {
        let advertisements: [CellViewModel]
    }
    
    enum NetworkError: Error {
        case invalidURL
        case noData
    }
    
    var collectionView: UICollectionView!
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .gray
        return indicator
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        setUpViews()
        setUpConstraints()
        activityIndicator.startAnimating()

        getJson(URL: "https://www.avito.st/s/interns-ios/main-page.json") { (result: Result<ResponseData, Error>) in
            switch result {
                case .success(let responseData):
                    self.data = responseData.advertisements
                    DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(Int.random(in: 0...9))) {
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                            self.activityIndicator.stopAnimating()
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        let errorController = ErrorViewController()
                        errorController.setErrorText("Ошибка загрузки данных: \(error.localizedDescription)")
                        self.navigationController?.pushViewController(errorController, animated: true)
                    }
            }
        }
        
        
        
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
    
    func getJson<T: Codable>(URL url: String, completion: @escaping (Result<T, Error>) -> Void){
        guard let url = URL(string: url) else {
               completion(.failure(NetworkError.invalidURL))
               return
           }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                       completion(.failure(NetworkError.noData))
                       return
            }
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    private func setUpViews(){
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    
    private func setUpConstraints(){
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    
        
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection secttion: Int) -> Int {
            return data.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
            let viewModel = data[indexPath.row]
            let string = viewModel.image_url
            let url = URL(string: string)
            cell.dogImageView.downloaded(from: url!, contentMode: .scaleAspectFill)
            cell.labelTitle.text = viewModel.title
            cell.labelPrice.text = viewModel.price
            cell.labelTime.text = self.formatDateString(viewModel.created_date)
            cell.labelLocation.text = viewModel.location
           
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: view.frame.width/2 - 20, height: 250)
        }
        
        func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.backgroundColor = UIColor.systemGray5.withAlphaComponent(0.5)
        }
        
        func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.backgroundColor = .clear
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let numAdvertisment = data[indexPath.row].id
            isLoadingDetails = true
            collectionView.reloadItems(at: [indexPath])
            getJson(URL: "https://www.avito.st/s/interns-ios/details/" + numAdvertisment + ".json") { (result: Result<CardViewModel, Error>) in
                DispatchQueue.main.async {
                            self.isLoadingDetails = false
                            collectionView.reloadItems(at: [indexPath]) 
                            
                            switch result {
                            case .success(let cardViewModel):
                                let carController = CardViewController()
                                carController.viewModel = cardViewModel
                                self.navigationController?.pushViewController(carController, animated: true)
                                
                            case .failure(let error):
                                DispatchQueue.main.async {
                                    let errorController = ErrorViewController()
                                    errorController.setErrorText("Ошибка загрузки данных: \(error.localizedDescription)")
                                    self.navigationController?.pushViewController(errorController, animated: true)
                                }
                            }
                        }
                }
        }
        
    }

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFill){
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                       print("Image Download Error:", error)
                       return
                   }
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {return}
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFill){
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

 

