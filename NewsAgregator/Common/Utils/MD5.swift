//
//  MD5.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 29.04.2022.
//

import Foundation
import CryptoKit

// MD5 in base64-encoded format
func MD5(string: String) -> String {
    let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())

    return Data(digest).base64EncodedString()
}
