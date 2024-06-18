//
//  InputAddButtonView.swift
//  GNUting
//
//  Created by 원동진 on 2/8/24.
// Code 정리 Start

// MARK: - 회원가입, 비밀번호찾기, 프로필 업데이트, InputView

import Foundation
import UIKit

// MARK: - Protocol

protocol PasswordDelegate: AnyObject {
    func passwordkeyBoardReturn(text: String)
}

protocol PasswordCheckDelegate: AnyObject {
    func passwordCheckKeyboardReturn(text: String)
}

protocol InputViewTextFiledDelegate: AnyObject {
    func shouldEndEdting()
}

protocol PhoneNumberDelegate: AnyObject {
    func phoneNumberKeyBoardReturn(textFieldCount: Int)
}

final class SignUPInputView: UIView {
    
    // MARK: - Properties
    
    public weak var passwordDelegate: PasswordDelegate? // 비밀번호 return action
    var passwordCheckDelegate: PasswordCheckDelegate? // 비밀번호 확인
    var inputViewTextFiledDelegate: InputViewTextFiledDelegate? // return or 입력이 끝났을때 action
    var phoneNumberDelegate: PhoneNumberDelegate? // return or 입력이 끝났을때 action
    var textFieldType: SignUpInputViewType? // inputView 타입
    
    // MARK: - SubViews
    
    private lazy var inputTextTypeLabel: UILabel = {
        let label = UILabel()
        label.font = Pretendard.medium(size: 14)
        
        return label
    }()
    
    private lazy var inputTextField : UITextField = {
        let textField = UITextField()
        textField.font = Pretendard.regular(size: 12)
        textField.delegate = self
        
        return textField
    }()
    
    
    private let bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "EAEAEA")
        
        return view
    }()
    private lazy var inputCheckLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(named: "PrimaryColor")
        label.font = Pretendard.bold(size: 12)
        label.isHidden = true
        label.numberOfLines = 2
        
        return label
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubViews()
        setAutoLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout Helpers

extension SignUPInputView {
    private func setAddSubViews() {
        self.addSubViews([inputTextTypeLabel,inputTextField,bottomLine,inputCheckLabel])
    }

    private func setAutoLayout() {
        inputTextTypeLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        inputTextField.snp.makeConstraints { make in
            make.top.equalTo(inputTextTypeLabel.snp.bottom).offset(14)
            make.left.right.equalToSuperview()
        }
        
        bottomLine.snp.makeConstraints { make in
            make.top.equalTo(inputTextField.snp.bottom).offset(6)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        inputCheckLabel.snp.makeConstraints { make in
            make.top.equalTo(bottomLine.snp.bottom).offset(4)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - Method private

extension SignUPInputView {
    private func format(mask: String, phone: String) -> String { // 전화번호 format 함수
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        
        return result
    }
}

// MARK: - Method public

extension SignUPInputView{
    public func setInputTextTypeLabel(text: String) {
        inputTextTypeLabel.text = text
    }
    
    public func setPlaceholder(placeholder: String) {
        inputTextField.placeholder = placeholder
    }
    
    public func setTextField(text: String) {
        inputTextField.text = text
    }
    
    public func isEmpty() -> Bool {
        return inputTextField.text?.count == 0 ? true : false
    }
    
    public func setInputCheckLabel(isHidden: Bool, text: String?, success: Bool) {
        inputCheckLabel.isHidden = isHidden
        inputCheckLabel.text = text
        
        if success {
            inputCheckLabel.textColor = UIColor(named: "SecondaryColor")
        } else {
            inputCheckLabel.textColor = UIColor(named: "PrimaryColor")
        }
    }
    
    public func getTextFieldText() -> String {
        inputTextField.text ?? ""
    }
    
    public func setKeyboardTypeNumberPad() {
        inputTextField.keyboardType = .numberPad
    }
    
    public func setSecureTextEntry() {
        inputTextField.isSecureTextEntry = true
    }
}

// MARK: - Delegate

extension SignUPInputView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        bottomLine.backgroundColor = UIColor(named: "PrimaryColor")
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        bottomLine.backgroundColor = UIColor(hexCode: "EAEAEA")
        if textFieldType == .password {
            passwordDelegate?.passwordkeyBoardReturn(text: textField.text ?? "")
        } else if textFieldType == .passwordCheck {
            passwordCheckDelegate?.passwordCheckKeyboardReturn(text: textField.text ?? "")
        } else if textFieldType == .phoneNumber {
            phoneNumberDelegate?.phoneNumberKeyBoardReturn(textFieldCount: textField.text?.count ?? 0)
        }
        
        inputViewTextFiledDelegate?.shouldEndEdting()
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textFieldType == .password {
            passwordDelegate?.passwordkeyBoardReturn(text: textField.text ?? "")
        } else if textFieldType == .passwordCheck {
            passwordCheckDelegate?.passwordCheckKeyboardReturn(text: textField.text ?? "")
        } else if textFieldType == .phoneNumber {
            phoneNumberDelegate?.phoneNumberKeyBoardReturn(textFieldCount: textField.text?.count ?? 0)
        }
        
        inputViewTextFiledDelegate?.shouldEndEdting()
        
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        switch textFieldType {
        case .phoneNumber:
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = format(mask:"XXX-XXXX-XXXX", phone: newString)
            return false
        case .name:
            guard textField.text?.count ?? 0 < 8 else { return false }
        case .nickname:
            guard textField.text?.count ?? 0 < 10 else { return false }
        case .studentID:
            guard textField.text?.count ?? 0 < 2 else { return false }
        case .introduce:
            guard textField.text?.count ?? 0 < 30 else { return false }
        default:
            break
        }
        return true
    }
    
}
