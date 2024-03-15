//
//  BoardSettingButton.swift
//  GNUting
//
//  Created by 원동진 on 3/15/24.
//

import UIKit

class BoardSettingButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension BoardSettingButton {
    func setButton(text: String) {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("\(text)", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: Pretendard.Bold.rawValue, size: 20)!]))
        config.baseForegroundColor = .black
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 50, bottom: 10, trailing: 50)
        self.configuration = config
    }
}
