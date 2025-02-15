//
//  ReportReasonCheckButton.swift
//  GNUting
//
//  Created by 원동진 on 2/25/24.
//

// MARK: - ReportReasonView 항목 체크 버튼

import UIKit

class ReportReasonCheckButton: UIButton {
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetView

extension ReportReasonCheckButton {
    func setConfiguration(buttonText:  String) {
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = AttributedString("\(buttonText)", attributes: AttributeContainer([NSAttributedString.Key.font: Pretendard.regular(size: 12) ?? .systemFont(ofSize: 12)]))
        configuration.image = UIImage(named: "DisSelectedIImg")
        configuration.baseForegroundColor = .black
        configuration.imagePlacement = .leading
        configuration.imagePadding = 10
        configuration.titleAlignment = .leading
        configuration.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 0, bottom: 10, trailing: 10)
        self.configuration = configuration
        self.configurationUpdateHandler = {  button in
            var configuration = button.configuration
            configuration?.image = button.isSelected ? UIImage(named: "SelectedImg") : UIImage(named: "DisSelectedIImg")
            configuration?.baseBackgroundColor = .clear
            button.configuration = configuration
        }
        self.changesSelectionAsPrimaryAction = true
        self.sizeToFit()
    }
}
