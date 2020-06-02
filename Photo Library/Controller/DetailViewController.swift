//
//  DetailViewController.swift
//  Photo Library
//
//  Created by Ben Clarke on 16/05/2020.
//  Copyright © 2020 Ben Clarke. All rights reserved.
//

import UIKit
import CoreImage

class DetailViewController: UIViewController {
    
    var photo: Photo?
    
    var selectedPhotoIndex: Int?
    var photos = [Photo]()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var intensitySlider: UISlider!
    @IBOutlet weak var changeFilterBtn: UIButton!
    
    var currentImage: UIImage!
    var context: CIContext!
    var currentFilter: CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Photo Editor 🎨"
        navigationItem.backBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveImgToApp))
        
        loadData()
        
        formatUI()
        
        // Core Img Manipulation
        context = CIContext()
        currentFilter = CIFilter(name: "CIVignette")
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
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
    
    @objc func saveImgToApp() {
        guard let index = selectedPhotoIndex else { return }
        guard let image = imageView.image else { return }
        let imageName = photos[index].image
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 1.0) {
            try? jpegData.write(to: imagePath)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
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
    
    private func editPhotoName(name: String) {
        guard let index = selectedPhotoIndex else { return }
        photos[index].name = name
        nameLabel.text = name
        save()
    }
    
    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
    }
    
    @IBAction func changeFilter(_ sender: UIButton) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPhotoEffectNoir", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    private func setFilter(action: UIAlertAction) {
        guard currentImage != nil else { return }
        guard let actionTitle = action.title else { return }
        
        currentFilter = CIFilter(name: actionTitle)
        changeFilterBtn.setTitle(actionTitle, for: .normal)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    @IBAction func saveToLibrary(_ sender: Any) {
        if let image = imageView.image {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        } else {
            showAC(messageTitle: "No image selected", message: "Please load an image before trying to save!")
        }
    }
    
    private func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensitySlider.value, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(intensitySlider.value * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(intensitySlider.value * 10, forKey: kCIInputScaleKey) }
        if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKeyPath: kCIInputCenterKey) }
        
        // Core Image manipulation
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimage = context.createCGImage(outputImage, from: outputImage.extent)  {
            let processedImage = UIImage(cgImage: cgimage)
            imageView.image = processedImage
        }
    }
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAC(messageTitle: "Save error", message: error.localizedDescription)
        } else {
            showAC(messageTitle: "Saved ✅", message: "Your altered image has been saved to your photos.")
        }
    }
    
    private func showAC(messageTitle: String, message: String) {
        let ac = UIAlertController(title: messageTitle, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        ac.view.tintColor = UIColor(named: K.colours.tintColour)
        present(ac, animated: true)
    }
    
    private func formatUI() {
        cancelButton.roundedBtn()
        imageView.roundedImg()
        
        cancelButton.alpha = 0
        imageView.alpha = 0
        
        UIView.animate(withDuration: 1.0) {
            self.cancelButton.alpha = 1.0
            self.imageView.alpha = 1.0
        }
        
        guard let index = selectedPhotoIndex else { return }
        photo = photos[index]
        guard let currentPhoto = photo else { return }
        
        let path = getDocumentsDirectory().appendingPathComponent(currentPhoto.image)
        currentImage = UIImage(contentsOfFile: path.path)
        
        imageView.image = currentImage
        nameLabel.text = currentPhoto.name
        dateLabel.text = "Date: \(currentPhoto.date)"
        
    }
    
}
