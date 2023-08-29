//
//  CardViewModel.swift
//  avito
//
//  Created by Александра Угольнова on 28.08.2023.
//

import Foundation

struct CardViewModel: Codable {
    let id: String
    let title: String
    let price: String
    let location: String
    let image_url: String
    let created_date: String
    let description: String
    let email: String
    let phone_number: String
    let address: String
}
