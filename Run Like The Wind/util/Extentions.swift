//
//  Extentions.swift
//  Run Like The Wind
//
//  Created by Yarden Barak on 08/07/2021.
//

import Foundation

extension Date {

 static func getCurrentDate() -> String {

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"

        return dateFormatter.string(from: Date())

    }
}
