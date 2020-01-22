//
//  ImageCell.swift
//  PersistenceLab
//
//  Created by Tanya Burke on 1/22/20.
//  Copyright © 2020 Tanya Burke. All rights reserved.
//

import UIKit
import ImageKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var photosImageView: UIImageView!
    
    func configureCell(with imageURL: String){
        photosImageView.getImage(with: imageURL) { [weak self] (result) in
            switch result{
            case .failure:
                DispatchQueue.main.async {                    self?.photosImageView.image = UIImage(named: "exclaimationmark-triangle")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    self?.photosImageView.image = image
                }
                
            }
        }
    }
}
