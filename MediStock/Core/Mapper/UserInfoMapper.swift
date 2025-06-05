//
//  UserInfoMapper.swift
//  MediStock
//
//  Created by Bruno Evrard on 26/05/2025.
//

import Foundation

struct UserInfoMapper {
    
    static func mapToViewData(_ userInfo: UserInfo) -> UserInfoViewData {
        return .init(
            idAuth: userInfo.idAuth,
            displayName: userInfo.displayName,
            email: userInfo.email
        )
    }
    
    static func mapToModel(_ viewData: UserInfoViewData) -> UserInfo {
        return .init(
            idAuth: viewData.idAuth,
            displayName: viewData.displayName,
            email: viewData.email
        )
    }
}
