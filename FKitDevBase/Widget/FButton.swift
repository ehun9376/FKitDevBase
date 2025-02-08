//
//  FButton.swift
//  TestDevBase
//
//  Created by 陳逸煌 on 2025/2/7.
//

import UIKit

class FButton: UIButton {
    
    private var onTap: (() -> Void)?
    
    init(title: String, imageName: String? = nil, cornerRadius: CGFloat = 0, backgroundColor: UIColor = .clear, onTap: (() -> Void)? = nil) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.setImage(.init(named: imageName ?? ""), for: .normal)
        self.semanticContentAttribute = .forceRightToLeft
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.onTap = onTap
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        onTap?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
