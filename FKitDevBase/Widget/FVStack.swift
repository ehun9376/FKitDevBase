//
//  FVStack.swift
//  TestDevBase
//
//  Created by 陳逸煌 on 2025/2/7.
//

import UIKit


class VStackWidget: UIView {
    
    private let stackView = UIStackView()
    
    var crossAlignment: UIStackView.Alignment = .center {
        didSet { self.stackView.alignment = self.crossAlignment }
    }
    
    var mainAlignment: VStackAlignment = .center {
        didSet { self.setupStackView() }
    }
    
    var mainAxisSize: MainAxisSize = .min {
        didSet { setupStackView() }
    }
    
    var spacing: CGFloat = 10 {
        didSet { stackView.spacing = spacing }
    }
    
    var distribution: UIStackView.Distribution = .fill {
        didSet { setupStackView() }
    }
    
    var widgets: [UIView] = [] {
        didSet { setupStackView() }
    }
    
    var heightConstraint: NSLayoutConstraint?
    
    init(mainAxisSize: MainAxisSize = .min, distribution: UIStackView.Distribution = .fill, mainAlignment: VStackAlignment = .center, crossAlignment: UIStackView.Alignment = .center, spacing: CGFloat = 10, children: [UIView] = []) {
        self.widgets = children
        self.mainAlignment = mainAlignment
        self.distribution = distribution
        self.mainAxisSize = mainAxisSize
        self.crossAlignment = crossAlignment
        self.spacing = spacing
        super.init(frame: .zero)
        setupStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.mainAxisSize == .max, let superView = superview {
            heightConstraint?.isActive = false
            heightConstraint = self.heightAnchor.constraint(equalTo: superView.heightAnchor)
            heightConstraint?.isActive = true
        }
        
    }
    
    private func setupStackView() {
        stackView.removeFromSuperview()
        stackView.axis = .vertical
        stackView.spacing = spacing
        stackView.alignment = crossAlignment
        stackView.distribution = distribution
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        widgets.forEach { stackView.addArrangedSubview($0) }
        
        updateStackViewConstraints()
    }
    
    func updateStackViewConstraints() {
        NSLayoutConstraint.deactivate(stackView.constraints)
                
        switch mainAlignment {
        case .center:
            switch self.mainAxisSize {
            case .max:
                NSLayoutConstraint.activate([
                    stackView.topAnchor.constraint(equalTo: self.topAnchor),
                    stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                    stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                    stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                ])
               
            
            case .min:
                NSLayoutConstraint.activate([
                    stackView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor),
                    stackView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor),
                    stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                    stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                    stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                ])
            }
        case .top:
      
            switch self.mainAxisSize {
            case .max:
                NSLayoutConstraint.activate([
                    stackView.topAnchor.constraint(equalTo: self.topAnchor),
                    stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                    stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                    stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                ])
               
            
            case .min:
                NSLayoutConstraint.activate([
                    stackView.topAnchor.constraint(equalTo: self.topAnchor),
                    stackView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor),
                    stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                    stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                ])
              
            }
        case .bottom:
            switch self.mainAxisSize {
       
            case .max:
                NSLayoutConstraint.activate([
                    stackView.topAnchor.constraint(equalTo: self.topAnchor),
                    stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                    stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                    stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                ])
            case .min:
                NSLayoutConstraint.activate([
                    stackView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor),
                    stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                    stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                    stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                ])
            }
        }
    }
    
    private func checkOverflow() {
        guard let superview = superview else { return }
        let totalHeight = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        
        if totalHeight > superview.frame.height {
            print("⚠️ VStack 超出允許高度！")
        }
    }
}
