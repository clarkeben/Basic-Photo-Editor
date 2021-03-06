//
//  Photo.swift
//  Photo Library
//
//  Created by Ben Clarke on 14/05/2020.
//  Copyright © 2020 Ben Clarke. All rights reserved.
//

import Foundation

struct Photo: Codable {
    
    public var name: String
    public var image: String
    public var date: String
    
    init(name: String, image: String, date: String) {
        self.name = name
        self.image = image
        self.date = date
    }
    
}
