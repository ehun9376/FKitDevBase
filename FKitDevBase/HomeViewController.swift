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
}

class HomeViewModelImpl: HomeViewModel {
    var selectedIndex: ObservableValue<Int> = ObservableValue(0)
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
        self.viewModel.selectedIndex.value = 50
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
                        })
                            .padding(),
                    ]
                ).container(backgroundColor: .red, cornerRadius: 15,borderWidth: 2, borderColor: .black)
            }).safeArea().setContentHugging(.defaultHigh, for: .vertical).setContentCompressionResistance(.defaultHigh, for: .vertical),
            
            FListViewBuilder<Any, Int>(
                data: [.init(header: 1, rows: [1, 2, 3, 4, 5]),
                       .init(header: 2, rows: [6, 7, 8, 9, 10, 11, 12])],
                headerBuilder: { item, section in
                    return HStackWidget(
                        mainAxisSize: .min,
                        mainAlignment: section == 1 ? .right : .left,
                        crossAlignment: .center,
                        children: [
                            FLabel(text: "Add\(item)", font: UIFont.boldSystemFont(ofSize: 24), alignment: .center),
                            FButton(title: "Login") { self.handleLogin() },
                        ]
                    ).container(backgroundColor: .yellow)
                },
                cellBuilder: { item, row  in
                    return HStackWidget(
                        mainAxisSize: .min,
                        mainAlignment: .center,
                        crossAlignment: .center,
                        children: [
                            FLabel(text: "Add\(item)",
                                   font: UIFont.boldSystemFont(ofSize: 24),
                                   alignment: .center).onTap {
                                       print("Tapped\(row.row)")
                                   },
                            FButton(title: "Login") { self.handleLogin() }.padding(),
                        ]
                    ).container(backgroundColor: .brown)
                        
                        
                }
            )
            .sizeBox(width: UIScreen.main.bounds.width)
            .setContentHugging(.defaultLow, for: .vertical)
            .setContentCompressionResistance(.defaultLow, for: .vertical),
            
            HStackWidget(mainAxisSize: .max,distribution: .fillEqually, children: [
                FButton(title: "Login",
                        cornerRadius: 10,
                        backgroundColor: .red,
                        onTap: {
                            self.handleLogin()
                        }),
                FButton(title: "Login", onTap: { self.handleLogin() }),
                FButton(title: "Login", onTap: { self.handleLogin() }),
            ]).container(backgroundColor: .darkGray).sizeBox(width: UIScreen.main.bounds.width, height: 40)
            
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
