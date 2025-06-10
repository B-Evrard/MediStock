//
//  HistoryEntryViewData.swift
//  MediStock
//
//  Created by Bruno Evrard on 04/06/2025.
//

import Foundation

struct HistoryEntryViewData: Hashable {
    var id: String?
    var action: HistoryAction
    var details: String
    var modifiedAt: Date
    var modifiedByUserName: String
    
    init(historyEntry: HistoryEntry)
    {
        self.id = historyEntry.id
        self.action = HistoryAction.from(historyEntry.action)
        self.details = historyEntry.details
        self.modifiedAt = historyEntry.modifiedAt
        self.modifiedByUserName = historyEntry.modifiedByUserName
    }
    
    var ligne1: String {
        return "\(modifiedAt.formattedDateString) - \(action.display) by \(modifiedByUserName)"
    }
    
    var detailsAccess: String {
        return details.replacingOccurrences(of: "-->", with: "to")
    }
}
