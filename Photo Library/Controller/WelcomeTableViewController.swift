//
//  TableViewController.swift
//  Photo Library
//
//  Created by Ben Clarke on 13/05/2020.
//  Copyright © 2020 Ben Clarke. All rights reserved.
//

import UIKit

class WelcomeTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var photos = [Photo]()
    var currentIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = K.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(addNewPhotoCamera))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPhotoRoll))
        
//        tableView.reloadWithBounceAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return photos.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ImageTableViewCell else { fatalError("Unable to dequeue a reusable cell")}
        
        let photo = photos[indexPath.row]
        let path = getDocumentsDirectory().appendingPathComponent(photo.image)
        
        cell.cellImg.image = UIImage(contentsOfFile: path.path)
        cell.txtLabel.text = photo.name
        cell.dateLabel.text = photo.date
        
        cell.accessoryView = addDiscolsureIndicatorCell()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.fadeInCell()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            photos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            save()
        } else {
            print("No action required")
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        currentIndex = indexPath.row
        performSegue(withIdentifier: K.segueToDetail, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if segue.identifier == K.segueToDetail { }
        guard let detailVC = segue.destination as? DetailViewController else { return }
        
        if let index = currentIndex {
            detailVC.selectedPhotoIndex = index
        }
    }
    
    func todaysDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        
        return result
    }
    
    
    //MARK: - Imagepickerview delegate methods
    @objc func addNewPhotoCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let vc =  UIImagePickerController()
            vc.sourceType = .camera
            vc.allowsEditing = true
            vc.delegate = self
            present(vc, animated: true)
        } else {
            showErrorAlert(title: "Camera error", message: "Please check device and try again!")
        }
    }
    
    func showErrorAlert(title: String, message: String) {
        let ac = UIAlertController(title: "\(title) ⚠️", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        ac.view.tintColor = UIColor(named: K.colours.tintColour)
        present(ac, animated: true)
    }
    
    @objc func addNewPhotoRoll() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        // Create unique identifier for image, retreview documents director loc. Write image as Data object and save
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let photo = Photo(name: "Photo \(photos.count)", image: imageName, date: todaysDate())
        photos.append(photo)
        save()
        tableView.reloadData()
        
        dismiss(animated: true)
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
    
    
}

