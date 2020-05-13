//
//  TableViewController.swift
//  Photo Library
//
//  Created by Ben Clarke on 13/05/2020.
//  Copyright © 2020 Ben Clarke. All rights reserved.
//

import UIKit

class WelcomeTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = K.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(addNewPhotoCamera))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPhotoRoll))
        
        
        tableView.reloadWithBounceAnimation()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ImageTableViewCell else { fatalError("Unable to dequeue a reusable cell")}
        cell.cellImg.image = UIImage(named: "default-img1")
        cell.txtLabel.text = "Photo  1"

        cell.accessoryView = addDiscolsureIndicator()
    
        return cell
    }
    
    func addDiscolsureIndicator() -> UIView {
        let accessoryView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 50))
        let accessoryViewImage = UIImageView(image: UIImage(named: K.images.chevron))
        accessoryViewImage.center = CGPoint(x: 12, y: 25)
        accessoryViewImage.image = accessoryViewImage.image?.withRenderingMode(.alwaysTemplate)
        accessoryViewImage.tintColor = UIColor(named: K.colours.tintColour)
        accessoryView.addSubview(accessoryViewImage)
        return accessoryView
    }
    
    
    //MARK: - Imagepickerview delegate methods
    @objc func addNewPhotoCamera() {
        
    }
    
    @objc func addNewPhotoRoll() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        <#code#>
    }
    

}

