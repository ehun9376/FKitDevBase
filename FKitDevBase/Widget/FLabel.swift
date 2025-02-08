//
//  FLabel.swift
//  TestDevBase
//
//  Created by 陳逸煌 on 2025/2/7.
//

import UIKit

class FLabel: UILabel {
    init(text: String, font: UIFont = UIFont.systemFont(ofSize: 17), alignment: NSTextAlignment = .left) {
        super.init(frame: .zero)
        self.text = text
        self.font = font
        self.textAlignment = alignment
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
