//
//  ViewController2ViewController.swift
//  ToDoList_2.0
//
//  Created by мария баженова on 20.07.2023.
//

import UIKit

final class TaskTextField: UITextField {
    private let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 40)
    init(placeholder: String) {
        super.init(frame: .zero)
        setupTextField(placeholder: placeholder)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override func editingRect (forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    private func setupTextField(placeholder: String) {
        font = UIFont.systemFont(ofSize: 17)
        keyboardAppearance = .default
        isUserInteractionEnabled = true
        returnKeyType = UIReturnKeyType.done
        textColor = .black
        layer.cornerRadius = 5
        backgroundColor = .white
        attributedPlaceholder = NSAttributedString(string: placeholder)
        heightAnchor.constraint(equalToConstant: 120).isActive = true
        widthAnchor.constraint(equalToConstant: 343).isActive = true
    }

}

