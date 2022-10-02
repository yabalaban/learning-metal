//
//  String+Extensions.swift
//  learning-metal
//
//  Created by Alexander Balaban.
//

import Foundation

extension String {
    var fileName: String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }

    var fileExtension: String {
        return URL(fileURLWithPath: self).pathExtension
    }
}
