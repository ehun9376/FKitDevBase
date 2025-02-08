//
//  WidgetFixer.swift
//  TestDevBase
//
//  Created by 陳逸煌 on 2025/2/7.
//

import UIKit

// 讓所有 UIView 都可以直接使用 .padding(), .center() 等方法
extension UIView {
    
    @discardableResult
    func setContentHugging(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> UIView {
        setContentHuggingPriority(priority, for: axis)
        return self
    }
    
    @discardableResult
    func setContentCompressionResistance(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> UIView {
        setContentCompressionResistancePriority(priority, for: axis)
        return self
    }
    
    func container(backgroundColor: UIColor = .clear, cornerRadius: CGFloat = 0, borderWidth: CGFloat = 0, borderColor: UIColor = .clear, clipsToBounds: Bool = false) -> UIView {
        let container = UIView()
        container.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = backgroundColor
        container.layer.cornerRadius = cornerRadius
        container.layer.borderWidth = borderWidth
        container.layer.borderColor = borderColor.cgColor
        container.clipsToBounds = clipsToBounds
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: container.topAnchor),
            self.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
        
    }
    
    func padding(_ insets: UIEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)) -> UIView {
        let container = UIView()
        container.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: container.topAnchor, constant: insets.top),
            self.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: insets.left),
            self.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -insets.right),
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -insets.bottom)
        ])
        
        return container
    }
    
    func safeArea() -> UIView {
        let container = UIView()
        container.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: container.safeAreaLayoutGuide.topAnchor),
            self.leadingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: container.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        return container
    }
    
    func center() -> UIView {
        let container = UIView()
        container.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        return container
    }
    
    func expanded(_ flex: CGFloat = 1) -> UIView {
        let container = UIView()
        container.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let heightConstraint = self.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: flex)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true
        
        return container
    }
    
    func flex() -> UIView {
        let view = UIView()
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
           
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
           
         
           return self
    }
    
    func sizeBox(width: CGFloat? = nil, height: CGFloat? = nil) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        return self
    }
    
    func singelChildScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: scrollView.topAnchor),
            self.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        return scrollView
    }
    
    
    func onTap(_ action: @escaping () -> Void) -> TapView {
        let tapView = TapView(action: action)
        tapView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: tapView.topAnchor),
            self.leadingAnchor.constraint(equalTo: tapView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: tapView.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: tapView.bottomAnchor)
        ])
        
        tapView.isUserInteractionEnabled = true
        tapView.addGestureRecognizer(UITapGestureRecognizer(target: tapView, action: #selector(tapView.onTapAction)))
        
        return tapView
      
    }
}

class TapView: UIView {
    var action: (() -> Void)?
    
    @objc func onTapAction() {
        action?()
    }
    
    init(action: (()->())? = nil) {
        self.action = action
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

