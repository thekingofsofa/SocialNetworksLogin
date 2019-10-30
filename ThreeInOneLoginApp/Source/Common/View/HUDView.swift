//
//  HUDView.swift
//  ThreeInOneLoginApp
//
//  Created by Иван Барабанщиков on 10/29/19.
//  Copyright © 2019 Ivan Barabanshchykov. All rights reserved.
//

import UIKit

private let horizontalSpacing: CGFloat = 20
private let verticalSpacing: CGFloat = 10
private let font = UIFont.boldSystemFont(ofSize: 16)

class HUDView: UIView {

    enum HudInset {
        case top(inset: CGFloat)
        case bottom(inset: CGFloat)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI() {
        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.9)
        layer.cornerRadius = 5
    }
    
    func addLabel(withText text: String) {
        let label = UILabel(frame: CGRect(
            x: horizontalSpacing,
            y: verticalSpacing,
            width: frame.width-2*horizontalSpacing,
            height: frame.height-2*verticalSpacing
        ))
        label.text = text
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.textColor = UIColor.white
        label.adjustsFontSizeToFitWidth = true
        self.addSubview(label)
    }

    class func prefferedFrame(for text:String,
                              in view: UIView,
                              inset: HudInset) -> CGRect {
        let width = min(
            text.width(withConstrainedHeight: .greatestFiniteMagnitude, font: font),
            view.bounds.width - 4*horizontalSpacing
        )
        let height = text.height(withConstrainedWidth: width, font: font)
        switch inset {
        case .bottom(let inset):
            return CGRect(
                x: (view.bounds.width - width - 2*horizontalSpacing)/2,
                y: view.bounds.height - inset - height,
                width: width + 2*horizontalSpacing,
                height: height + 2*verticalSpacing
            )
        case .top(let inset):
            return CGRect(
                x: (view.bounds.width - width - 2*horizontalSpacing)/2,
                y: inset,
                width: width + 2*horizontalSpacing,
                height: height + 2*verticalSpacing
            )
        }
    }
    
    class func show(_ text: String,
                    in view: UIView?,
                    for seconds: CGFloat,
                    inset: HudInset = .bottom(inset: 100)) {
        guard let view = view else { return }
        let hud = HUDView(frame: HUDView.prefferedFrame(for: text, in: view, inset: inset))
        hud.addLabel(withText: text)
        hud.alpha = 0
        view.addSubview(hud)
        
        UIView.animate(withDuration: 0.2, animations: {
            hud.alpha = 1
        }) { (finished) in
            if finished {
                UIView.animate(withDuration: 0.2,
                               delay: TimeInterval(seconds),
                               options: .curveEaseInOut,
                               animations: {
                    hud.alpha = 0
                }, completion: { (finished) in
                    hud.removeFromSuperview()
                })
            }
        }
    }
}
