//
//  EditView.swift
//  SwiftUI-StateRestoration-transcribe
//
//  Created by kazunori.aoki on 2021/10/29.
//

import SwiftUI

struct EditView: View {
    @EnvironmentObject var productsViewModel: ProductsModel

    // 現在のViewが他のViewから呼ばれているかのフラグ
    // 現在のViewを閉じる処理
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var product: Product

    // 保存された値か、現在の値を使用するかのフラグ
    @SceneStorage("EditView.useSavedValues") var useSavedValues = true

    // Restoration value
    @SceneStorage("EditView.editTitle") var editName: String = ""
    @SceneStorage("EditView.editYear") var editYear: String = ""
    @SceneStorage("EditView.editPrice") var editPrice: String = ""

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var imageWidth: CGFloat {
        horizontalSizeClass == .compact ? 100 : 280
    }
    var imageHeight: CGFloat {
        horizontalSizeClass == .compact ? 80 : 260
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("")) {
                    HStack {
                        Spacer()
                        Image(product.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: imageWidth, height: imageHeight)
                            .clipped()
                        Spacer()
                    }
                }

                Section(header: Text("NameTitle")) {
                    TextField("AccessibilityNameField", text: $editName)
                }
                Section(header: Text("YearTitle")) {
                    TextField("AccessibilityYearField", text: $editYear)
                        .keyboardType(.numberPad)
                }
                Section(header: Text("PriceTitle")) {
                    TextField("AccessibilityPriceField", text: $editPrice)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationBarTitle(Text("EditProductTitle"), displayMode: .inline)

            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("CancelTitle", action: cancel)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("DoneTitle", action: done)
                        .disabled(editName.isEmpty)
                }
            }
        }

        .onAppear {
            // シーンストレージを復元に使用するかを決定する
            if useSavedValues {
                editName = product.name
                editYear = String(product.year)
                editPrice = String(product.price)
                useSavedValues = false // dismissされるまでSceneStorageを使用する
            }
        }
    }

    func cancel() {
        dismiss()
    }

    func done() {
        save()
        dismiss()
    }

    func dismiss() {
        useSavedValues = true
        self.presentationMode.wrappedValue.dismiss()
    }

    func save() {
        product.name = editName
        product.year = Int(editYear)!
        product.price = Double(editPrice)!
        productsViewModel.save()
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        let product = Product(
            identifier: UUID(uuidString: "fa542e3d-4895-44b6-942f-e112101d5160")!,
            name: "Cherries",
            imageName: "Cherries",
            year: 2015,
            price: 10.99)
        EditView(product: product)
    }
}
