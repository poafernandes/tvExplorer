//
//  StringExt.swift
//  tvExplorer
//
//  Created by Alexandre Porto Alegre Fernandes on 13/05/23.
//

import Foundation

extension String {
    func obtainYearFromString() -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: self) else {
            return nil
        }
        
        let year = Calendar.current.component(.year, from: date)
        
        return year
    }
}