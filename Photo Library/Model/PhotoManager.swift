//
//  PhotoManager.swift
//  Photo Library
//
//  Created by Ben Clarke on 28/05/2020.
//  Copyright © 2020 Ben Clarke. All rights reserved.
//

import Foundation

struct PhotoManager {
    
    static var photos = [Photo]()
    
    static func save(photos: [Photo]) {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(photos) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "photos")
        } else {
            print("Failed to save photo!")
        }
    }
    
    private func loadData()  {
        let defaults = UserDefaults.standard
        if let savedPhotos = defaults.object(forKey: "photos") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                PhotoManager.photos = try jsonDecoder.decode([Photo].self, from: savedPhotos)
            } catch {
                print("Failed to load photos!")
            }
        }
    }
    
}
