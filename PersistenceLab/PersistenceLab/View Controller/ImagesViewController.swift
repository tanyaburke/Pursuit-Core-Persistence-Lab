//
//  ViewController.swift
//  PersistenceLab
//
//  Created by Tanya Burke on 1/21/20.
//  Copyright © 2020 Tanya Burke. All rights reserved.
//


import UIKit
import AVFoundation
import NetworkHelper


// we want to use AVMakeRect() to maintain image aspect ratio

class ImagesViewController: UIViewController {

     @IBOutlet weak var photosCollectionView: UICollectionView!
       @IBOutlet weak var searchBar: UISearchBar!

       var photos = [Photo](){
           didSet{
               DispatchQueue.main.async {
                   self.photosCollectionView.reloadData()
               }
           }
       }
       
       override func viewDidLoad() {
           super.viewDidLoad()
           // Do any additional setup after loading the view.
           loadData(with: "begin")
           
        searchBar.delegate = self
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
       }
       
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           guard let cell = sender as? ImageCell else {
               fatalError("failed to downcast as Image Cell")
           }
           
           guard let detailsVC = segue.destination as? DetailsViewController, let indexPath = photosCollectionView.indexPath(for: cell) else{
               fatalError("failed to segue to detailsViewController")
           }
           
           let photo = photos[indexPath.row]
           
           detailsVC.passedObj = photo
       }

      
       
       private func loadData(with query: String){
           PhotoAPIClient.getPhotos(with: query) { [weak self](result) in
               switch result{
               case .failure(let appError):
                   DispatchQueue.main.async {
                       self?.showAlert(title: "Error", message: "\(appError)")
                   }
               case .success(let photo):
                   self?.photos = photo
               }
           }
       }

   }

   extension ImagesViewController: UISearchBarDelegate{
       func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
           searchBar.resignFirstResponder()
           guard let query = searchBar.text else {
               return
           }
           loadData(with: query)
       }
   }

   extension ImagesViewController: UICollectionViewDelegateFlowLayout {
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           
           let interItemSpacingV:CGFloat = 3
           let numberOfItemsV:CGFloat = 5
           let maxWidth = UIScreen.main.bounds.size.width
           let totalSpacingV = interItemSpacingV * numberOfItemsV
           let itemWidth : CGFloat = (maxWidth - totalSpacingV) / numberOfItemsV
           return CGSize(width: itemWidth, height: itemWidth)
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
       }
   }

   extension ImagesViewController: UICollectionViewDataSource {
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return photos.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           guard let cell = photosCollectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else {
               fatalError("failed to downcast to ImageCell")
           }
           
           let photo = photos[indexPath.row]
           cell.configureCell(with: photo.previewURL)
           return cell
       }
   }
