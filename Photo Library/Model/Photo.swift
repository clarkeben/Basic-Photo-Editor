//
//  Photo.swift
//  Photo Library
//
//  Created by Ben Clarke on 14/05/2020.
//  Copyright © 2020 Ben Clarke. All rights reserved.
//

import Foundation

struct Photo {
    
    public var name: String
    public var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
}
