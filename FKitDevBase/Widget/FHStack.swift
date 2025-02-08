//
//  FHVStack.swift
//  TestDevBase
//
//  Created by 陳逸煌 on 2025/2/7.
//

import UIKit

class HStackWidget: UIView {
    
    private let stackView = UIStackView()
    
    var mainAxisSize: MainAxisSize = .max {
        didSet { setupStackView() }
    }
    
    var mainAlignment: HStackAlignment = .center {
        didSet { setupStackView() }
    }
 
    var crossAlignment: UIStackView.Alignment = .center {
        didSet { stackView.alignment = crossAlignment }
    }
    
    var spacing: CGFloat = 10 {
        didSet { stackView.spacing = spacing }
    }
    
    var widgets: [UIView] = [] {
        didSet { setupStackView() }
    }
    
    var distribution: UIStackView.Distribution = .fill {
        didSet { setupStackView() }
    }
    
    private var widthConstraint: NSLayoutConstraint?
    
    init(mainAxisSize: MainAxisSize = .max,distribution: UIStackView.Distribution = .fill, mainAlignment: HStackAlignment = .center, crossAlignment: UIStackView.Alignment = .center, spacing: CGFloat = 10, children: [UIView] = []) {
        self.widgets = children
        self.spacing = spacing
        self.distribution = distribution
        self.mainAlignment = mainAlignment
        self.mainAxisSize = mainAxisSize
        self.crossAlignment = crossAlignment
        super.init(frame: .zero)
        self.setupStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStackView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.removeFromSuperview()
        stackView.axis = .horizontal
        stackView.spacing = spacing
        stackView.alignment = crossAlignment
        stackView.distribution = distribution
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(stackView)
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        widgets.forEach { stackView.addArrangedSubview($0) }
        updateStackViewConstraints()
        
    }
    
    func updateStackViewConstraints() {
        NSLayoutConstraint.deactivate(stackView.constraints)
        
      
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        switch mainAlignment {
        case .center:
            switch self.mainAxisSize {
            case .max:
                NSLayoutConstraint.activate([
                    stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                    stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                    stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                ])
            
            case .min:
                NSLayoutConstraint.activate([
                    stackView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor),
                    stackView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor),
                    stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                ])
            }
        case .left:
      
            switch self.mainAxisSize {
            case .max:
                NSLayoutConstraint.activate([
                    stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                    stackView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor),
                ])
            
            case .min:
                NSLayoutConstraint.activate([
                    stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                    stackView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor),
                ])
            }
        case .right:
            switch self.mainAxisSize {
       
            case .max:
                NSLayoutConstraint.activate([
                    stackView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor),
                    stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                ])
            case .min:
                NSLayoutConstraint.activate([
                    stackView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor),
                    stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                ])
            }
        }
        
        guard let superView = self.superview else { return }
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalTo: superView.widthAnchor)
        ])
        
        
    
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let superView = self.superview else { return }
        if let widthConstraint = self.widthConstraint {
            self.removeConstraint(widthConstraint)
        }
        
        self.widthConstraint = self.widthAnchor.constraint(equalTo: superView.widthAnchor)
        self.widthConstraint?.isActive = true
        
    }


}
