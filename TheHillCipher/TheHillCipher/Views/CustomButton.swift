//
//  CustomButton.swift
//  TheHillCipher
//
//  Created by Olteanu Andrei on 21/10/2018.
//  Copyright © 2018 Andrei Olteanu. All rights reserved.
//

import UIKit

internal enum SelectorStateType {
    case touchDragInside
    case touchDragOutside
    case initial
}

class RoundedAppleButton: UIButton {

    // MARK: - Private Properties

    private var selectorState: SelectorStateType = .initial
    private let selectionFeedbackGenerator = UISelectionFeedbackGenerator()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        layer.cornerRadius = 10
        backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)

        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        addTarget(self, action: #selector(touchDragOutside), for: .touchDragOutside)
        addTarget(self, action: #selector(touchDragInside), for: .touchDragInside)
        addTarget(self, action: #selector(touchDragInside), for: .touchDown)

    }

    @objc private func touchUpInside() {
        selectorState = .touchDragOutside
        animate(dragInside: false)
        selectionFeedbackGenerator.selectionChanged()
    }

    @objc private func touchDragInside() {
        if selectorState != .touchDragInside {
            selectorState = .touchDragInside
            animate(dragInside: true)
        }
    }

    @objc private func touchDragOutside() {
        if selectorState != .touchDragOutside {
            selectorState = .touchDragOutside
            animate(dragInside: false)
        }
    }

    // MARK: - Animations

    private func animate(dragInside: Bool) {
        UIView.animate(withDuration: 0.15) {
            self.alpha = dragInside ? 0.5 : 1.0
        }
    }
}
