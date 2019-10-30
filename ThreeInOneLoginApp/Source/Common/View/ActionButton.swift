//
//  ActionButton.swift
//  ThreeInOneLoginApp
//
//  Created by Иван Барабанщиков on 10/29/19.
//  Copyright © 2019 Ivan Barabanshchykov. All rights reserved.
//

import UIKit

class ActionButton: UIButton {
  
    enum ActionButtonType {
        case icon
        case text
        case full
    }
    
    var action: Action? {
        didSet {
            update()
        }
    }
    
    var type: ActionButtonType = .icon {
        didSet {
            update()
        }
    }
    
    // MARK: - Initialize
    init(action: Action = Action(title: nil, iconName: nil, handler: {}),
         type: ActionButtonType = .full) {
        self.type = type
        self.action = action
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    // MARK: - Configuration
    func configure() {
        update()
        contentHorizontalAlignment = .left
        addTarget(self, action: #selector(onClick), for: .touchUpInside)
    }
    
    func update() {
        setTitle(
            (type == .text || type == .full) ? action?.title ?? "" : "",
            for: .normal
        )
        setImage(
            (type == .icon || type == .full)
                ? UIImage(named: action?.iconName ?? "")?.withRenderingMode(.alwaysTemplate)
                : nil,
            for: .normal)
        setImage((type == .icon || type == .full) ? UIImage(named: action?.iconName ?? "")?.withRenderingMode(.alwaysTemplate) : nil, for: .highlighted)
    }
    
    // MARK: - Actions
    @objc private func onClick() {
        action?.handler()
    }
    
    func setupUI(bordered: Bool = false, textColor: UIColor = .blue, secondaryColor: UIColor = .clear) {
        setTitleColor(textColor, for: .normal)
        imageView?.tintColor = textColor
        tintColor = textColor
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        backgroundColor = secondaryColor
        contentHorizontalAlignment = .center
        
        layer.cornerRadius = 5
        layer.borderWidth = bordered ? 2 : 0
        layer.borderColor = textColor.cgColor
    }
}
