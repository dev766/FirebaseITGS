//
//  File.swift
//  FirebaseITGS
//
//  Created by Apple on 05/07/22.
//

import Foundation
class ChatOptionTypeModel: NSObject {
    
    var optionImage, optionName: String?
    var cellType: chatOptionsType
    
    init(optionImage: String = "", optionName: String = "", cellType: chatOptionsType){
        self.optionImage = optionImage
        self.optionName = optionName
        self.cellType = cellType
    }
}
