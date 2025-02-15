//
//  ChatTableViewCell.swift
//  GNUting
//
//  Created by 원동진 on 2/29/24.
//

import UIKit

// MARK: - 채팅목록 리스트

class ChatTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identi = "ChatTableViewCellid"
    
    // MARK: - SubViews
    
    private lazy var upperView = UIView()
    private lazy var userImageView = makeImageView(imageName: "photoImg")
    private lazy var newChatImageView = makeImageView(imageName: "NewChatImage")
    
    private lazy var middleTopStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 6
        return stackView
    }()
    
    private lazy var middleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 3
        return stackView
    }()
    
    private lazy var chatRoomNameListLabel: UILabel = {
        let label = UILabel()
        label.font = Pretendard.medium(size: 15)
        
        return label
    }()
    
    private lazy var subInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "DisableColor")
        label.font = Pretendard.medium(size: 12)
        
        return label
    }()
    
    private lazy var titleLabel: BasePaddingLabel =  {
        let label = BasePaddingLabel(padding: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3),
                                     textColor: UIColor(hexCode: "696969"),
                                     font: Pretendard.regular(size: 11)!)
        label.backgroundColor = UIColor(hexCode: "F4F2F7")
        label.setLayerCorner(cornerRaius: 4)
        
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexCode: "666666")
        label.font = Pretendard.regular(size: 12)
        
        return label
    }()
    
    private lazy var messageTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexCode: "C0C0C0")
        label.font = Pretendard.regular(size: 11)
        
        return label
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
    override func prepareForReuse() {
        super.prepareForReuse()
        userImageView.image = nil
    }
    
}
extension ChatTableViewCell{
    
    // MARK: - Layout Helpers
    
    private func setAddSubViews() {
        contentView.addSubview(upperView)
        upperView.addSubViews([userImageView, middleStackView, messageTimeLabel,newChatImageView])
        middleStackView.addStackSubViews([middleTopStackView, messageLabel])
        middleTopStackView.addStackSubViews([chatRoomNameListLabel, subInfoLabel, titleLabel])
    }
    
    private func setAutoLayout() {
        upperView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12.5)
            make.left.right.equalToSuperview().inset(25)
        }
        
        userImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.height.width.equalTo(45)
            make.bottom.equalToSuperview()
        }
        
        newChatImageView.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.top)
            make.right.equalTo(userImageView.snp.right).offset(3)
        }
        
        middleStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(3)
            make.left.equalTo(userImageView.snp.right).offset(11)
            make.bottom.greaterThanOrEqualToSuperview().offset(-3)
        }
        
        messageTimeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.greaterThanOrEqualTo(middleStackView.snp.right).offset(20)
            make.right.equalToSuperview()

        }
        chatRoomNameListLabel.setContentCompressionResistancePriority(.init(rawValue: 751), for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        middleStackView.setContentHuggingPriority(.init(250), for: .horizontal)
        messageTimeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        messageTimeLabel.setContentHuggingPriority(.init(251), for: .horizontal)
        
    }
    
    // MARK: - Make ImageView
    
    private func makeImageView(imageName: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        
        return imageView
    }
    
    private func getCacheImageData(imageString: String?) {
        let cacheKey = NSString(string: imageString ?? "")
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) { // 해당 Key 에 캐시이미지가 저장되어 있으면 이미지를 사용
            DispatchQueue.main.async {
                self.userImageView.image = cachedImage
                self.userImageView.layer.cornerRadius = 22.5
                self.userImageView.layer.masksToBounds = true
            }
        } else {
            setImageFromStringURL(stringURL: imageString) { image in
                DispatchQueue.main.async {
                    self.userImageView.image = image
                    self.userImageView.layer.cornerRadius = 22.5
                    self.userImageView.layer.masksToBounds = true
                }
            }
        }
    }
}
extension ChatTableViewCell {
    func setChatTableViewCell(chatRoomUserProfileImages: String?, hasNewMessage: Bool, nameList: String, subInfoString: String?, title: String, lastMessage: String, lastMessageTime: String) {
        getCacheImageData(imageString: chatRoomUserProfileImages)
        newChatImageView.isHidden = hasNewMessage ? false : true
        chatRoomNameListLabel.text = nameList
        subInfoLabel.text = subInfoString
        subInfoLabel.isHidden = subInfoString ==  nil ? true : false
        titleLabel.text = title
        messageLabel.text = lastMessage
        messageTimeLabel.text = lastMessageTime
    }
}

