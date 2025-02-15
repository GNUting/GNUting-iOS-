//
//  UserDetailVC.swift
//  GNUting
//
//  Created by 원동진 on 4/9/24.
//

// MARK: - 프로필 클릭시 사용자 디테일 ViewController

import UIKit

final class UserDetailVC: BaseViewController {
    
    //MARK: - Properties
    
    var userDetailData: UserDetailModel?
     
    // MARK: - SubViews
    
    private lazy var userImageButton = UIButton()
    
    private lazy var userNickameLabel: UILabel = {
        let label = UILabel()
        label.font = Pretendard.medium(size: 16)
        
        return label
    }()
    
    private lazy var subInfoLabel: UILabel = { // 학번 & 학과 Label
        let label = UILabel()
        label.font = Pretendard.medium(size: 12)
        label.textColor = UIColor(named: "DisableColor")
        
        return label
    }()
    
    private lazy var reportButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 27, bottom: 10, trailing: 27)
        config.attributedTitle = AttributedString("신고하기", attributes: AttributeContainer([NSAttributedString.Key.font: Pretendard.medium(size: 16) ?? .boldSystemFont(ofSize: 16),NSAttributedString.Key.foregroundColor: UIColor(named: "PrimaryColor") ?? .red]))
        config.titleAlignment = .center
        
        let button = UIButton(configuration: config)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
        button.addTarget(self, action: #selector(tapReportButton), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserData()
        setAddSubViews()
        setAutoLayout()
        setUserDetailViewLabel()
        setUserDetailViewImageView()
        setNavigationBar()
    }
}

// MARK: - Layout Helpers

extension UserDetailVC {
    private func setAddSubViews() {
        view.addSubViews([userImageButton, userNickameLabel, subInfoLabel, reportButton])
    }
    
    private func setAutoLayout() {
        userImageButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(200)
        }
        
        userNickameLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        subInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(userNickameLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        reportButton.snp.makeConstraints { make in
            make.top.equalTo(subInfoLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-100)
        }
    }
}

// MARK: - SetView

extension UserDetailVC {
    private func setNavigationBar() {
        setNavigationBarPresentType(title: "")
    }
    
    private func setUserDetailViewLabel() {
        userNickameLabel.text = userDetailData?.nickname
        subInfoLabel.text = "\(userDetailData?.userStudentID ?? "학번") | \(userDetailData?.userDepartment ?? "학과")"
    }
    
    private func setUserDetailViewImageView() {
        setImageFromStringURL(stringURL: userDetailData?.imageURL) { image in
            DispatchQueue.main.async {
                self.userImageButton.setImage(image, for: .normal)
                self.userImageButton.layer.cornerRadius = self.userImageButton.layer.frame.size.width / 2
                self.userImageButton.layer.masksToBounds = true
            }
        }
    }
}


// MARK: - GET API

extension UserDetailVC {
    private func getUserData() { // 사용자 정보 Get
        APIGetManager.shared.getUserData { userData,response  in
            self.errorHandling(response: response)
            if userData?.result?.nickname == self.userDetailData?.nickname { // 사용자 정보와 비교하여 일치할 경우 신고하기 버튼 Hidden
                self.reportButton.isHidden = true
            }
        }
    }
}

// MARK: - Action

extension UserDetailVC {
    @objc private func tapReportButton() { // 신고하기 버튼 클릭
        let vc = ReportVC()
        
        vc.userNickname = self.userDetailData?.nickname ?? "유저이름"
        presentViewController(viewController: vc, modalPresentationStyle: .fullScreen)
    }
}
