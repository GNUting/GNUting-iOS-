//
//  DetailDateBoardVC.swift
//  GNUting
//
//  Created by 원동진 on 2/20/24.
//

import UIKit

class DetailDateBoardVC: UIViewController{
    var boardID: Int = 0
    var userInfos: [UserInfosModel] = []
    var postUserInfos : User?
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Bold.rawValue, size: 20)
        label.textAlignment = .left
        return label
    }()
    private lazy var userInfoView : UserInfoView = {
        let view = UserInfoView()
        view.userImageButton.userImageButtonDelegate = self
        return view
    }()
    private lazy var contentTextView : UITextView  = {
        let textView = UITextView()
        textView.font = UIFont(name: Pretendard.Regular.rawValue, size: 18)
        textView.textColor = .black
        textView.isEditable = false

        return textView
    }()
    private lazy var chatPeopleViewButton : UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapchatPeopleViewButton), for: .touchUpInside)
        return button
    }()
    private lazy var requetChatButton : PrimaryColorButton = { // 어떻게 할지 정해야된다. 내글에서는 필요가 없기때문에
        let button = PrimaryColorButton()
        button.setText("채팅 신청하기")
        button.addTarget(self, action: #selector(tapRequetChatButton), for: .touchUpInside)
        return button
    }()
    private lazy var detailDateBoardSetView : DetailDateBoardSetView = {
        let view = DetailDateBoardSetView()
        view.isHidden = true
        
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addSubViews()
        setAutoLayout()
        bringToDetailDateBoardSetView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getBoardDetailData()
        setNavigationBar()
    }
}
extension DetailDateBoardVC{
    private func bringToDetailDateBoardSetView() {
        self.view.bringSubviewToFront(detailDateBoardSetView)
    }
    private func addSubViews() {
        view.addSubViews([titleLabel,userInfoView,contentTextView,chatPeopleViewButton,requetChatButton,detailDateBoardSetView])
    }
    private func setAutoLayout(){
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Spacing.top)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        userInfoView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(userInfoView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        contentTextView.setContentHuggingPriority(.init(249), for: .vertical)
        chatPeopleViewButton.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        requetChatButton.snp.makeConstraints { make in
            make.top.equalTo(chatPeopleViewButton.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
        }
        detailDateBoardSetView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.right.equalToSuperview().offset(Spacing.right)
        }
    }
    private func setNavigationBar(){
        setNavigationBar(title: "과팅 게시판")

        let settingButton = UIBarButtonItem(image: UIImage(named: "SettingButton"), style: .plain, target: self, action: #selector(tapSettingButton(_:)))
        settingButton.tintColor = UIColor(named: "IconColor")
        self.navigationItem.rightBarButtonItem = settingButton
    }
    private func setChatPeopleViewButton(memeberCount: Int) {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("과팅 멤버 정보 \(memeberCount)명", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: Pretendard.Medium.rawValue, size: 16)!]))
        config.image = UIImage(named: "ChatImg")
        config.baseForegroundColor = UIColor(named: "PrimaryColor")
        config.imagePlacement = .leading
        config.imagePadding = 5
        chatPeopleViewButton.configuration = config
    }
    
}



// MARK: - Button Action
extension DetailDateBoardVC{
    @objc private func tapSettingButton(_ sender: UIButton){
        sender.isSelected.toggle()
        if sender.isSelected{
            detailDateBoardSetView.isHidden = false
        }else{
            detailDateBoardSetView.isHidden = true
        }
    }
    
    @objc private func didTapchatPeopleViewButton(){
        let vc = DateJoinMemberVC()
        vc.modalPresentationStyle = .fullScreen
        vc.userInfos = self.userInfos
        self.present(vc, animated: true)
    }
    
    @objc private func tapRequetChatButton(){
        let vc = RequestChatVC()
        vc.boardID = boardID
        pushViewContoller(viewController: vc)
    }
}

// MARK: - detailDateBoardSetViewButton Action Delegate

extension DetailDateBoardVC : OtherPostDelegate {
    func didTapReportButton() { // 신고하기
        let vc = ReportVC()
        
        self.navigationItem.rightBarButtonItem?.isSelected = false
        vc.boardID = boardID
        detailDateBoardSetView.isHidden = true
        presentFullScreenVC(viewController: vc)
    }
}
extension DetailDateBoardVC: MyPostDelegate {
    func didTapUpDateButton() {
        detailDateBoardSetView.isHidden = true
        let vc = UpdatePostVC()
        vc.setPostTestView(title: titleLabel.text ?? "", content: contentTextView.text)
        vc.boardID = boardID
        vc.memberDataList = userInfos
        pushViewContoller(viewController: vc)
    }
    
    func didTapDeleteButton() {
        APIDeleteManager.shared.deletePostText(boardID: boardID) { response in
            if response.isSuccess {
                self.successHandlingPopAction(message: response.message)
            } else {
                self.errorHandling(response: response)
            }
        }
        
    }
}
// MAKR : 어디서 push 된지 체크

extension DetailDateBoardVC {
    func setPushMypostVersion() {
        requetChatButton.isHidden = true
        chatPeopleViewButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
        }
        detailDateBoardSetView.myPost(isMypost: true)
        detailDateBoardSetView.MyPostDelegate = self
    }
    func setPushBoardList() {
        detailDateBoardSetView.otherPostDelegate = self
        detailDateBoardSetView.myPost(isMypost: false)
    }
}

extension DetailDateBoardVC {
    private func getBoardDetailData() {
        
        APIGetManager.shared.getBoardDetail(id: boardID) { boardDetailData,response  in
            self.errorHandling(response: response)
            guard let result = boardDetailData?.result else { return }
            let user = result.user
            let chatEnabled = result.status
            if chatEnabled == "CLOSE" {
                self.requetChatButton.backgroundColor = UIColor(hexCode: "979C9E")
                self.chatPeopleViewButton.snp.makeConstraints { make in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
                }
            }
            self.postUserInfos = user
            self.titleLabel.text =  result.title
            self.contentTextView.text = result.detail
            self.userInfos = result.inUser
            self.userInfoView.setUserInfoView(userImage: user.image, userNickname: user.nickname, major: user.department, StudentID: user.studentId, writeDataeLabel: result.time)
            self.setChatPeopleViewButton(memeberCount: result.inUser.count)
        }
    }
}
extension DetailDateBoardVC: UserImageButtonDelegate {
    func tappedAction() {
        let vc = UserDetailVC()
        vc.userNickName = postUserInfos?.nickname
        vc.imaegURL = postUserInfos?.image
        
        presentFullScreenVC(viewController: vc)
    }
    
    
}
