//
//  FSelectorWidget.swift
//  TestDevBase
//
//  Created by 陳逸煌 on 2025/2/7.
//

import UIKit

class SelectorWidget<T>: UIView {
    
    private let observable: ObservableValue<T>
    private let builder: (T) -> UIView
    private var currentView: UIView?
    
    init(observable: ObservableValue<T>, builder: @escaping (T) -> UIView) {
        self.observable = observable
        self.builder = builder
        super.init(frame: .zero)
        setupBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBinding() {
        observable.bind { [weak self] value in
            self?.updateView(value)
        }
    }
    
    private func updateView(_ value: T) {
        currentView?.removeFromSuperview()
        let newView = builder(value)
        addSubview(newView)
        newView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newView.topAnchor.constraint(equalTo: self.topAnchor),
            newView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            newView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            newView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        currentView = newView
    }
}
