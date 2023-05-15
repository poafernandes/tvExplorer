//
//  StringExt.swift
//  tvExplorer
//
//  Created by Alexandre Porto Alegre Fernandes on 13/05/23.
//

import Foundation

extension String {
    func obtainYearFromString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: self) else {
            return ""
        }
        
        let year = Calendar.current.component(.year, from: date)
        
        return String(year)
    }
}

extension String{
    var stripTags : String{
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
