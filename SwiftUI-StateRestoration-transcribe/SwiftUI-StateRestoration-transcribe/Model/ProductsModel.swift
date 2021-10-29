//
//  ProductsModel.swift
//  SwiftUI-StateRestoration-transcribe
//
//  Created by kazunori.aoki on 2021/10/29.
//

import Foundation

class ProductsModel: Codable, ObservableObject {
    @Published var products: [Product] = []

    private enum CodingKeys: String, CodingKey {
        case products
    }

    private let dataFileName = "Products"

    init() {
        if let codedData = try? Data(contentsOf: dataModelURL()) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Product].self, from: codedData) {
                products = decoded
            }
        } else {
            products = Bundle.main.decode("products.json")
            save()
        }
    }

    // MARK: Codable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(products, forKey: .products)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        products = try values.decode(Array.self, forKey: .products)
    }

    private func documentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }

    private func dataModelURL() -> URL {
        let docURL = documentDirectory()
        return docURL.appendingPathComponent(dataFileName)
    }

    func save() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(products) {
            do {
                try encoded.write(to: dataModelURL())
            } catch {
                print("Couldn't write to save file: " + error.localizedDescription)
            }
        }
    }
}

// MARK: - Bundle
extension Bundle {
    func decode(_ file: String) -> [Product] {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) in bundle")
        }
        let decoder = JSONDecoder()
        guard let loaded = try? decoder.decode([Product].self, from: data) else {
            fatalError("Failed to decode \(file) in bundle")
        }
        return loaded
    }
}
