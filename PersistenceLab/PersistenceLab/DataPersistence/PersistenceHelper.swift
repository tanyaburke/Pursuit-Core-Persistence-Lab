//
//  PersistenceHelper.swift
//  PersistenceLab
//
//  Created by Tanya Burke on 1/21/20.
//  Copyright © 2020 Tanya Burke. All rights reserved.
//

import Foundation


enum DataPersistanceError: Error{
    case savingError(Error)
    case fileDoesNotExist(String)
    case noData
    case decodingError(Error)
    case deletingError(Error)
}

class PersistanceHelper{
    private static var photos = [Photo]()
    private static var filename = "photoSaveData.plist"
    
    private static func save() throws {
        let url = FileManager.pathToDocumentsDirectory(with: filename)
        
        do{
            let data = try PropertyListEncoder().encode(photos)
            try data.write(to: url, options: .atomic)
        }catch{
            throw DataPersistanceError.savingError(error)
        }
    }
    
    static func create(photo: Photo) throws {
        photos.append(photo)
        do{
            try save()
        } catch{
            throw DataPersistanceError.savingError(error)
        }
    }
    
    static func load() throws -> [Photo] {
        let url = FileManager.pathToDocumentsDirectory(with: filename)
        if FileManager.default.fileExists(atPath: url.path){
            if let data = FileManager.default.contents(atPath: url.path) {
                do {
                    try photos = PropertyListDecoder().decode([Photo].self, from: data)
                } catch {
                    throw DataPersistanceError.decodingError(error)
                }
            } else {
                throw DataPersistanceError.noData
            }
        } else {
            throw DataPersistanceError.fileDoesNotExist(filename)
        }
        return photos
    }
    
    static func delete(photo index: Int) throws {
        photos.remove(at: index)
        do {
            try save()
        } catch {
            throw DataPersistanceError.deletingError(error)
        }
    }
}
