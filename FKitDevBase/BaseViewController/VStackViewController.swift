//
//  VStackViewController.swift
//  TestDevBase
//
//  Created by 陳逸煌 on 2025/2/7.
//

import UIKit

class VStackViewController: UIViewController {
    
    private let stackView = UIStackView()
    
    var mainAxisSize: MainAxisSize = .min {
        didSet { self.setupStackView() }
    }
    
    var mainAlignment: VStackAlignment = .center {
        didSet { self.updateStackViewConstraints() }
    }
    
    var crossAlignment: UIStackView.Alignment = .center {
        didSet { self.updateStackViewConstraints() }
    }
        
    var spacing: CGFloat = 10 {
        didSet { self.setupStackView() }
    }
    
    var distribution: UIStackView.Distribution = .equalSpacing {
        didSet { self.setupStackView() }
    }
    
    private var widgets: [UIView] = [] {
        didSet { self.setupStackView() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupStackView()
        self.widgets = createWidgets()
    }
    
    private func setupStackView() {
        self.stackView.removeFromSuperview()
        self.stackView.axis = .vertical
        self.stackView.spacing = self.spacing
        self.stackView.alignment = self.crossAlignment
        self.stackView.distribution = self.distribution
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(stackView)
        self.stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        self.widgets.forEach { self.stackView.addArrangedSubview($0) }
        
        self.updateStackViewConstraints()
    }
    
    private func updateStackViewConstraints() {
        NSLayoutConstraint.deactivate(self.stackView.constraints)
        
        switch mainAlignment {
        case .center:
            
            switch mainAxisSize {
            case .min:
                NSLayoutConstraint.activate([
                    self.stackView.topAnchor.constraint(greaterThanOrEqualTo: self.view.topAnchor),
                    self.stackView.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor),
                    self.stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    self.stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                ])
            case .max:
                NSLayoutConstraint.activate([
                    self.stackView.topAnchor.constraint(equalTo: self.view.topAnchor),
                    self.stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                    self.stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    self.stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    self.stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    self.stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                ])
            }
            

        case .top:
            switch mainAxisSize {
            case .min:
                NSLayoutConstraint.activate([
                    self.stackView.topAnchor.constraint(equalTo: view.topAnchor),
                    self.stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
                    self.stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    self.stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                ])
            case .max:
                NSLayoutConstraint.activate([
                    self.stackView.topAnchor.constraint(equalTo: view.topAnchor),
                    self.stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                    self.stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    self.stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                ])
            }
        case .bottom:
            switch mainAxisSize {
            case .min:
                NSLayoutConstraint.activate([
                    self.stackView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor),
                    self.stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                    self.stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    self.stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                ])
            case .max:
                NSLayoutConstraint.activate([
                    self.stackView.topAnchor.constraint(equalTo: view.topAnchor),
                    self.stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                    self.stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    self.stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                ])
            }
        }
        self.stackView.setContentHuggingPriority(.required, for: .vertical)
        self.stackView.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    func createWidgets() -> [UIView] {
        return []
    }
    
    
}
