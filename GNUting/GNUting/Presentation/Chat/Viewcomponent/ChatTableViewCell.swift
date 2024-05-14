//
//  ChatTableViewCell.swift
//  GNUting
//
//  Created by 원동진 on 2/29/24.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    static let identi = "ChatTableViewCellid"
    private lazy var upperView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hexCode: "EAEAEA").cgColor
        view.layer.masksToBounds = true
        return view
    }()
    private lazy var userImageButton = UIButton()
    private lazy var firstStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 12
        
        return stackView
    }()
    private lazy var secondStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 5
        
        return stackView
    }()
    private lazy var chatTitleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Bold.rawValue, size: 16)
        
        return label
    }()
    
    private lazy var majorLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Regular.rawValue, size: 14)
        
        label.textColor = UIColor(hexCode: "767676")
        return label
    }()
    
    
    private lazy var newChatImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "NewChatImage")
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setAddSubViews()
        setAutoLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
  
    
}
extension ChatTableViewCell{
    private func setAddSubViews() {
        contentView.addSubViews([upperView,newChatImage])
        upperView.addSubViews([firstStackView,userImageButton])
        firstStackView.addStackSubViews([chatTitleLabel,majorLabel])
    }
    private func setAutoLayout(){
        newChatImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(22)
        }
        upperView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.bottom.equalToSuperview().offset(-12)
        }
        firstStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
        userImageButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.left.equalTo(firstStackView.snp.right).offset(5)
            make.bottom.equalToSuperview().offset(-12)
            make.height.width.equalTo(45)
        }
        
        firstStackView.setContentHuggingPriority(.init(250), for: .horizontal)
        userImageButton.setContentHuggingPriority(.init(251), for: .horizontal)
        userImageButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        
    }
    
}
extension ChatTableViewCell {
    func setChatTableViewCell(title: String, leaderUserDepartment: String, applyLeaderDepartment: String,chatRoomUserProfileImages: [String?],hasNewMessage: Bool) {
        chatTitleLabel.text = title
        majorLabel.text = "\(leaderUserDepartment) | \(applyLeaderDepartment)"
        if hasNewMessage {
            newChatImage.isHidden = false
        } else {
            newChatImage.isHidden = true
        }
        self.setImageFromStringURL(stringURL: chatRoomUserProfileImages.first as? String) { image in
            DispatchQueue.main.async {
                self.userImageButton.setImage(image, for: .normal)
                self.userImageButton.layer.cornerRadius = self.userImageButton.layer.frame.size.width / 2
                self.userImageButton.layer.masksToBounds = true
            }
        }
        
    }
}
