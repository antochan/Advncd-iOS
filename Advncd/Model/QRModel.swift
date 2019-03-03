//
//  QRModel.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/3.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import Foundation

struct QR: Codable, Equatable {
    let qrId: String
    let date: String
    let qrType: String
    let downloadURL: String

    
    init(qrId: String, date: String, qrType: String, downloadURL: String) {
        self.qrId = qrId
        self.date = date
        self.qrType = qrType
        self.downloadURL = downloadURL
    }
}

func ==(lhs:QR, rhs:QR) -> Bool { // Implement Equatable
    return lhs.qrId == rhs.qrId
}
