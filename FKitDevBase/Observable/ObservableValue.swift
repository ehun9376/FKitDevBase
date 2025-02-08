//
//  ObservableValue.swift
//  TestDevBase
//
//  Created by 陳逸煌 on 2025/2/7.
//

class ObservableValue<T> {
    var value: T {
        didSet {
            for observer in observers {
                observer(value)
            }
        }
    }
    
    private var observers: [(T) -> Void] = []
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ observer: @escaping (T) -> Void) {
        observers.append(observer)
        observer(value)
    }
}

