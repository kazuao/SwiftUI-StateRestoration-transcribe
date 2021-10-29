//
//  ContentView.swift
//  SwiftUI-StateRestoration-transcribe
//
//  Created by kazunori.aoki on 2021/10/29.
//

import SwiftUI

struct ContentView: View {
    // すべてのproductsを保存するデータモデル
    @EnvironmentObject var productsModel: ProductsModel

    // 全面表示家の判定に使用する
    @Environment(\.scenePhase) private var scenePhase

    // 現在選択中のproduct
    @SceneStorage("ContentView.selectedProduct") private var selectedProduct: String?

    // カラムサイズの作成
    let columns = Array(repeating: GridItem(.adaptive(minimum: 94, maximum: 120)), count: 3)

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(productsModel.products) { product in
                        NavigationLink(destination: DetailView(product: product, selectedProductID: $selectedProduct),
                                       tag: product.id.uuidString,
                                       selection: $selectedProduct) {
                            StackItemView(itemName: product.name, imageName: product.imageName)
                        }
                                       .padding(8)
                                       .buttonStyle(PlainButtonStyle())
                                       .onDrag {
                                           // iPadで、左か右にドラッグすると、新しいシーンが作成される
                                           let userActivity = NSUserActivity(activityType: DetailView.productUserActivityType)

                                           let localizedString = NSLocalizedString("DroppedProductTitle", comment: "Activity title with product name")
                                           userActivity.title = String(format: localizedString, product.name)

                                           userActivity.targetContentIdentifier = product.id.uuidString
                                           try? userActivity.setTypedPayload(product)

                                           return NSItemProvider(object: userActivity)
                                       }
                    }
                }
                .padding()
            }
            .navigationTitle("ProductsTitle")
        }
        .navigationViewStyle(StackNavigationViewStyle())

        .onContinueUserActivity(DetailView.productUserActivityType) { userActivity in
            if let product = try? userActivity.typedPayload(Product.self) {
                selectedProduct = product.id.uuidString
            }
        }
        .onChange(of: scenePhase) { newScenePhase in
            if newScenePhase == .background {
                // 状態遷移時にbackgroundにいた場合は、保存する
                productsModel.save()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ProductsModel())
    }
}

struct StackItemView: View {
    var itemName: String
    var imageName: String
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .font(.title)
                .scaledToFit()
                .cornerRadius(8.0)
            Text("\(itemName)")
                .font(.caption)
        }
    }
}

