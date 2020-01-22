//
//  ImageObjectFile.swift
//  PersistenceLab
//
//  Created by Tanya Burke on 1/22/20.
//  Copyright © 2020 Tanya Burke. All rights reserved.
//

import Foundation


struct ImageObject: Codable {
  let imageData: Data
  let date: Date
  let identifier = UUID().uuidString
}
