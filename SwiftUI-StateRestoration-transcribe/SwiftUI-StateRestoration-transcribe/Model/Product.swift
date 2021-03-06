//
//  Product.swift
//  SwiftUI-StateRestoration-transcribe
//
//  Created by kazunori.aoki on 2021/10/29.
//

import Foundation

class Product: Hashable, Identifiable, Codable, ObservableObject {
    let id: UUID
    let imageName: String
    @Published var name: String
    @Published var year: Int
    @Published var price: Double

    init(identifier: UUID, name: String, imageName: String, year: Int, price: Double) {
        self.name = name
        self.imageName = imageName
        self.year = year
        self.price = price
        self.id = identifier
    }

    // MARK: Equatable
    static func ==(lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id
    }

    // MARK: Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // MARK: Codable
    private enum CodingKeys: String, CodingKey {
        case name
        case imageName
        case year
        case price
        case identifier
    }

    // 永続保存用に使用する
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(imageName, forKey: .imageName)
        try container.encode(year, forKey: .year)
        try container.encode(price, forKey: .price)
        try container.encode(id, forKey: .identifier)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name       = try values.decode(String.self, forKey: .name)
        year       = try values.decode(Int.self, forKey: .year)
        price      = try values.decode(Double.self, forKey: .price)
        imageName  = try values.decode(String.self, forKey: .imageName)
        id         = try values.decode(UUID.self, forKey: .identifier)
    }
}
