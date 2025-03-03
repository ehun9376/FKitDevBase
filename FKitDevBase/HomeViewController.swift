//
//  LaunchViewController.swift
//  TestDevBase
//
//  Created by 陳逸煌 on 2025/2/7.
//

import UIKit
import SwiftUI
protocol HomeViewModel {
    var selectedIndex: ObservableValue<Int> { get }
    var positionList: ObservableValue<[PositionModel]> { get }
    var positionListPage: ObservableValue<Int> { get }
    func getPositionList() async
}

@MainActor
class HomeViewModelImpl: @preconcurrency HomeViewModel {
    var selectedIndex: ObservableValue<Int> = ObservableValue(0)
    var positionList: ObservableValue<[PositionModel]> = ObservableValue([])
    var positionListPage: ObservableValue<Int> = ObservableValue(1)
    
    
    func getPositionList() async {
        do {
            let param = [
                "page": self.positionListPage.value,
                "userID": "0850501",
                "fieldSort": "1",
                "ks": "行政",
                "sort": "desc",
                "pageSize": 20,
                "col": "ab",
                "dataType": 1,
                "status": 0,
                "currentPage": 1,
                "jobType": 6,
                "searchitem": 2,
                "tt":"1"
            ] as [String : Any]
            let result = try await ApiService.getPosition(parameter: param)
            
            if let errorMessage = result.errorMessage {
                print(errorMessage)
            } else if let model = result.model {
                //fix capture of 'self' with non-sendable type 'HomeViewModelImpl' in a `@Sendable` closure
                var value = self.positionList.value
                value.append(contentsOf: model)
                self.positionList.value = value
                self.selectedIndex.value = model.count
            }
            
            
        } catch {
            print(error)
        }
    }
}

class HomeViewController: VStackViewController {
    
    var viewModel: HomeViewModel!
    
    convenience init(viewModel: HomeViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spacing = 0
        self.mainAlignment = .top
        self.crossAlignment = .center
        self.distribution = .fill
        self.mainAxisSize = .max
        self.viewModel.positionListPage.bind { page in
            Task {
                await self.viewModel.getPositionList()
            }
        }
        
    }
    
    override func createWidgets() -> [UIView] {
        return [
            SelectorWidget(observable: self.viewModel.selectedIndex, builder: { index in
                return  VStackWidget(
                    mainAxisSize: .max,
                    mainAlignment: .top,
                    crossAlignment: .center,
                    children: [
                        FLabel(text: "Login\(index)",
                               font: .boldSystemFont(ofSize: 24),
                               alignment: .center),
                        FTextField(placeholder: "Enter username")
                            .padding(),
                        FTextField(placeholder: "Enter password")
                            .padding(),
                        FButton(title: "Login", onTap: { [weak self] in
                            guard let self = self else { return }
                            self.handleLogin()
                        }).padding(),
                    ]
                )
                .container(backgroundColor: .red, cornerRadius: 15,borderWidth: 2, borderColor: .black)
            })
            .safeArea()
            .setContentHugging(.defaultHigh, for: .vertical)
            .setContentCompressionResistance(.defaultHigh, for: .vertical),
            
            SelectorWidget(observable: self.viewModel.positionList,
                           update: { value, listView in
                               if let tableView = listView as? FListViewBuilder<Any, PositionModel> {
                                   tableView.updateData([.init(rows: value)])
                               }
                               
                           },
                           builder: { list in
                               return FListViewBuilder<Any, PositionModel>(
                                data: [.init(rows: list)],
                                cellBuilder: { item, row  in
                                    return HStackWidget(
                                        mainAxisSize: .min,
                                        mainAlignment: .center,
                                        crossAlignment: .center,
                                        children: [
                                            FLabel(text: "\(item.positionName ?? "")",
                                                   font: UIFont.boldSystemFont(ofSize: 24),
                                                   alignment: .center).onTap {
                                                       print("Tapped\(row.row)")
                                                   },
                                            FLabel(text: "\(item.companyName ?? "")",
                                                   font: UIFont.boldSystemFont(ofSize: 24),
                                                   alignment: .center).onTap {
                                                       print("Tapped\(row.row)")
                                                   },
                                        ]
                                    ).container(backgroundColor: .brown)
                                    
                                    
                                },
                                lastCellWillDisplay: { [weak self] in
                                    guard let self = self else { return }
                                    self.viewModel.positionListPage.value += 1
                                }
                               )
                               
                               .sizeBox(width: UIScreen.main.bounds.width)
                               .setContentHugging(.defaultLow, for: .vertical)
                               .setContentCompressionResistance(.defaultLow, for: .vertical)
                               
                           })
            
            
            
            .sizeBox(width: UIScreen.main.bounds.width)
            .setContentHugging(.defaultLow, for: .vertical)
            .setContentCompressionResistance(.defaultLow, for: .vertical),
            
            //            HStackWidget(mainAxisSize: .max,distribution: .fillEqually, children: [
            //                FButton(title: "Login",
            //                        cornerRadius: 10,
            //                        backgroundColor: .red,
            //                        onTap: {
            //                            self.handleLogin()
            //                        }),
            //                FButton(title: "Login", onTap: { self.handleLogin() }),
            //                FButton(title: "Login", onTap: { self.handleLogin() }),
            //            ]).container(backgroundColor: .darkGray).sizeBox(width: UIScreen.main.bounds.width, height: 40)
            
        ]
    }
    
    
    private func handleLogin() {
        self.viewModel.selectedIndex.value += 1
    }
}

//swift ui priview

#if DEBUG
// UIViewControllerRepresentable 用來包裝 UIKit 控制器
struct LaunchViewControllerRepresentable: UIViewControllerRepresentable {
    
    var viewModel: HomeViewModel
    
    func makeUIViewController(context: Context) -> HomeViewController {
        return HomeViewController(viewModel: viewModel)
    }
    
    func updateUIViewController(_ uiViewController: HomeViewController, context: Context) {
        // 更新視圖控制器的邏輯
    }
}

struct ContentView: View {
    var body: some View {
        LaunchViewControllerRepresentable(viewModel: HomeViewModelImpl())
            .edgesIgnoringSafeArea(.all) // 可以根據需要調整邊緣處理
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
