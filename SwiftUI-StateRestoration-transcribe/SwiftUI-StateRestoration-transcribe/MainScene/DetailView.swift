//
//  DetailView.swift
//  SwiftUI-StateRestoration-transcribe
//
//  Created by kazunori.aoki on 2021/10/29.
//

import SwiftUI

struct DetailView: View {
    // User Activity Type
    static let productUserActivityType = "com.k-aoki.SwiftUI-StateRestoration-transcribe.product"

    @ObservedObject var product: Product
    @Binding var selectedProductID: String?

    enum Tabs: String {
        case detail
        case photo
    }

    // View名.アイテム名がルール？
    // 復元ID: selected tab
    @SceneStorage("DetailView.selectedTab") private var selectedTab = Tabs.detail
    // 復元ID: presentation state for EditView
    @SceneStorage("DetailView.showEditView") private var showEditView = false

    var body: some View {
        TabView(selection: $selectedTab) {
            InfoTabView(product: product)
                .tabItem {
                    Label("DetailTitle", systemImage: "info.circle")
                }
                .tag(Tabs.detail)

            Image(product.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .border(Color("borderColor"), width: 1.0)
                .padding()
                .tabItem {
                    Label("PhotoTitle", systemImage: "photo")
                }
                .tag(Tabs.photo)
        }

        .sheet(isPresented: $showEditView) {
            EditView(product: product)
        }

        .toolbar {
            ToolbarItem {
                Button("EditTitle", action: { showEditView.toggle() })
            }
        }

        .userActivity(DetailView.productUserActivityType,
                      isActive: product.id.uuidString == selectedProductID) { userActivity in
            describeUserActivity(userActivity)
        }
                      .navigationTitle(product.name)
                      .navigationBarTitleDisplayMode(.inline)
    }

    func describeUserActivity(_ userActivity: NSUserActivity) {
        let returnProduct: Product! // 新しいインスタンスに設定される
        if let activityProduct = try? userActivity.typedPayload(Product.self) {
            returnProduct = Product(identifier: product.id,
                                    name: product.name,
                                    imageName: activityProduct.imageName,
                                    year: activityProduct.year,
                                    price: activityProduct.price)
        } else {
            returnProduct = product
        }

        let localizedString =
            NSLocalizedString("ShowProductTitle", comment: "Activity title with product name")
        userActivity.title = String(format: localizedString, product.name)

        userActivity.isEligibleForHandoff = true
        userActivity.isEligibleForSearch = true
        userActivity.targetContentIdentifier = returnProduct.id.uuidString
        try? userActivity.setTypedPayload(returnProduct)

    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let product = Product(
            identifier: UUID(uuidString: "fa542e3d-4895-44b6-942f-e112101d5160")!,
            name: "Cherries",
            imageName: "Cherries",
            year: 2015,
            price: 10.99)
        DetailView(product: product, selectedProductID: .constant(nil))
    }
}
