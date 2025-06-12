//
//  UserInfoMapper.swift
//  MediStock
//
//  Created by Bruno Evrard on 26/05/2025.
//

import Foundation

struct MediStockUserInfoMapper {
    
    static func mapToViewData(_ userInfo: UserModel) -> UserViewData {
        return .init(
            idAuth: userInfo.idAuth,
            displayName: userInfo.displayName,
            email: userInfo.email
        )
    }
    
    static func mapToModel(_ viewData: UserViewData) -> UserModel {
        return .init(
            idAuth: viewData.idAuth,
            displayName: viewData.displayName,
            email: viewData.email
        )
    }
}
