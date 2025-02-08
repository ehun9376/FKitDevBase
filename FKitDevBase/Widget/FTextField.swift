//
//  FTextField.swift
//  TestDevBase
//
//  Created by 陳逸煌 on 2025/2/7.
//

import UIKit

class FTextField: UITextField {
    
    private var textChanged: ((String) -> Void)?
    
    init(placeholder: String = "", onChanged: ((String) -> Void)? = nil) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.borderStyle = .roundedRect
        self.textChanged = onChanged
        self.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    @objc private func textDidChange() {
        textChanged?(self.text ?? "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
