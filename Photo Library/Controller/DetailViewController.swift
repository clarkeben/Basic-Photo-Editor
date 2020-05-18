//
//  DetailViewController.swift
//  Photo Library
//
//  Created by Ben Clarke on 16/05/2020.
//  Copyright © 2020 Ben Clarke. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var currentPhoto: Photo?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let unwrappedPhoto = currentPhoto else { return }
        let path = getDocumentsDirectory().appendingPathComponent(unwrappedPhoto.image)
        
        imageView.image = UIImage(contentsOfFile: path.path)
        nameLabel.text = unwrappedPhoto.name
        dateLabel.text = unwrappedPhoto.date
        
        formatUI()
    }
    
    @IBAction func editPressed(_ sender: Any) {
        
        let ac = UIAlertController(title: "Edit 🎨", message: "Edit the name of the photo", preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        ac.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            guard let newPhotoName = ac.textFields?[0].text else { return }
            print(newPhotoName)
        }))
        
        present(ac, animated: true)
        
    }
    
    @IBAction func donePressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func formatUI() {
        doneButton.roundedBtn()
        imageView.roundedImg()
    }
    
}
