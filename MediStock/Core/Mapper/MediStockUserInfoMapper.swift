//
//  UserInfoMapper.swift
//  MediStock
//
//  Created by Bruno Evrard on 26/05/2025.
//

import Foundation

struct MediStockUserInfoMapper {
    
    static func mapToViewData(_ userInfo: MediStockUser) -> MediStockUserViewData {
        return .init(
            idAuth: userInfo.idAuth,
            displayName: userInfo.displayName,
            email: userInfo.email
        )
    }
    
    static func mapToModel(_ viewData: MediStockUserViewData) -> MediStockUser {
        return .init(
            idAuth: viewData.idAuth,
            displayName: viewData.displayName,
            email: viewData.email
        )
    }
}
