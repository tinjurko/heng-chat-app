//
//  Date+Extensions.swift
//  henging_app
//
//  Created by Tin Jurkovic on 01.02.2022..
//

import Foundation

extension Date {
    func toMessageFormatString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "HH:mm a dd/MM" //Specify your format that you want
        return  dateFormatter.string(from: self)
    }
}
