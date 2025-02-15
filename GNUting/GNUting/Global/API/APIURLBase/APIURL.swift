//
//  APIURL.swift
//  GNUting
//
//  Created by 원동진 on 3/11/24.
//

import Foundation
enum EndPoint{
    case signUp
    case emailCheck
    case emailCheckChangePassword
    case checkNickname
    case login
    case logout
    case getUserData
    case getBoardData
    case searchGetBoardData
    case searchGetUserData
    case writeText
    case reportPost
    case reportUser
    case mypost
    case requestStatus
    case receivedState
    case fcmToken
    case updateProfile
    case checkMailVerify
    case searchMajor
    case updateAccessToken
    case setNewPassword
    case deleteUser
    case chatRoom
    case notification
    case notificationCheck
    case notificationSetting
    case notificationShowAllsetting
    case noteRead
    case noteApplyRemainCount
    case noteRegisterPost
    case eventIsOpenSever
    case eventParticipate
    var url : URL {
        switch self{
        case .login:
            return .makeForEndpoint(endPoint: "login")
        case .signUp:
            return .makeForEndpoint(endPoint: "signup")
        case .emailCheck:
            return .makeForEndpoint(endPoint: "mail")
        case .emailCheckChangePassword:
            return .makeForEndpoint(endPoint: "mail/findPassword")
        case .checkNickname:
            return .makeForEndpoint(endPoint: "check-nickname")
        case .getUserData:
            return .makeForEndpoint(endPoint: "board/user/myinfo")
        case .getBoardData:
            return .makeForEndpoint(endPoint: "board")
        case .searchGetBoardData:
            return .makeForEndpoint(endPoint: "board/search")
        case .searchGetUserData:
            return .makeForEndpoint(endPoint: "board/user/search")
        case .writeText:
            return .makeForEndpoint(endPoint: "board/save")
        case .reportPost:
            return .makeForEndpoint(endPoint: "boardReport")
        case .reportUser:
            return .makeForEndpoint(endPoint: "userReport")
        case .mypost:
            return .makeForEndpoint(endPoint: "board/myboard")
        case .requestStatus:
            return .makeForEndpoint(endPoint: "board/applications/applystate")
        case .receivedState:
            return .makeForEndpoint(endPoint: "board/applications/receivedstate")
        case .fcmToken:
            return .makeForEndpoint(endPoint: "savetoken")
        case .updateProfile:
            return .makeForEndpoint(endPoint: "update")
        case .checkMailVerify:
            return .makeForEndpoint(endPoint: "mail/verify")
        case .searchMajor:
            return .makeForEndpoint(endPoint: "search-department")
        case .updateAccessToken:
            return .makeForEndpoint(endPoint: "reIssueAccessToken")
        case .logout:
            return .makeForEndpoint(endPoint: "logout")
        case .setNewPassword:
            return .makeForEndpoint(endPoint: "setNewPassword")
        case .deleteUser:
            return .makeForEndpoint(endPoint: "deleteUser")
        case .chatRoom:
            return .makeForEndpoint(endPoint: "chatRoom")
        case .notification:
            return .makeForEndpoint(endPoint: "notification")
        case .notificationCheck:
            return .makeForEndpoint(endPoint: "notification/check")
        case .notificationSetting:
            return .makeForEndpoint(endPoint: "notificationSetting")
        case .notificationShowAllsetting:
            return .makeForEndpoint(endPoint: "notification/show/allsetting")
        case .noteRead:
            return .makeForEndpoint(endPoint: "memo")
        case .noteRegisterPost:
            return .makeForEndpoint(endPoint: "memo/save")
        case .noteApplyRemainCount:
            return .makeForEndpoint(endPoint: "memo/remaining")
        case .eventIsOpenSever:
            return .makeForEndpoint(endPoint: "event/server/check")
        case .eventParticipate:
            return.makeForEndpoint(endPoint: "event/participate")
        }
    }
}

private extension URL{
    static let baseURL = Bundle.main.testBaseURL
    static func makeForEndpoint(endPoint : String) -> URL{
        URL(string: baseURL + endPoint)!
    }
    func getBaseUrl() -> String{
        return URL.baseURL
    }
}
class BaseURL {
    static let shared = BaseURL()
    let urlString = Bundle.main.testBaseURL
}
