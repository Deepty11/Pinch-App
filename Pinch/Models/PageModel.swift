//
//  PageModel.swift
//  Pinch
//
//  Created by Rehnuma Reza Deepty on 10/4/23.
//

import Foundation

struct PageModel: Identifiable {
    var id: Int
    var imageName: String
}

extension PageModel {
    var thumbnailName: String {
        "thumb-\(imageName)"
    }
}
