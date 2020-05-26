//
//  DetailViewController.swift
//  Photo Library
//
//  Created by Ben Clarke on 16/05/2020.
//  Copyright © 2020 Ben Clarke. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var photo: Photo?
    
    var selectedPhotoIndex: Int?
    var photos = [Photo]()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var intensitySlider: UISlider!
    @IBOutlet weak var changeFilterBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        guard let index = selectedPhotoIndex else { return }
        photo = photos[index]
        guard let currentPhoto = photo else { return }
        
        let path = getDocumentsDirectory().appendingPathComponent(currentPhoto.image)
        
        imageView.image = UIImage(contentsOfFile: path.path)
        nameLabel.text = currentPhoto.name
        dateLabel.text = currentPhoto.date
        
        formatUI()
        
    }
    
    @IBAction func editPressed(_ sender: Any) {
        
        let ac = UIAlertController(title: "Edit 🎨", message: "Edit the name of the photo", preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        ac.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            guard let newPhotoName = ac.textFields?[0].text else { return }
            self?.editPhotoName(name: newPhotoName)
        }))
        
        ac.view.tintColor = UIColor(named: K.colours.tintColour)
        present(ac, animated: true)
        
    }
    
    @IBAction func donePressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(photos) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "photos")
        } else {
            print("Failed to save photo!")
        }
    }
    
    func loadData() {
        let defaults = UserDefaults.standard
        if let savedPhotos = defaults.object(forKey: "photos") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                photos = try jsonDecoder.decode([Photo].self, from: savedPhotos)
            } catch {
                print("Failed to load photos!")
            }
        }
    }
    
    func editPhotoName(name: String) {
        guard let index = selectedPhotoIndex else { return }
        photos[index].name = name
        nameLabel.text = name
        save()
    }
    
    @IBAction func intensityChanged(_ sender: Any) {
    }
    
    @IBAction func changeFilter(_ sender: Any) {
    }
    
    @IBAction func saveToLibrary(_ sender: Any) {
    }
    
    
    
    func formatUI() {
        doneButton.roundedBtn()
        imageView.roundedImg()
        
        doneButton.alpha = 0
        imageView.alpha = 0
        
        UIView.animate(withDuration: 1.0) {
            self.doneButton.alpha = 1.0
            self.imageView.alpha = 1.0
        }
    }
    
}
