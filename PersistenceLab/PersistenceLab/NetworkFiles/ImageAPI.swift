//
//  ImageAPI.swift
//  PersistenceLab
//
//  Created by Tanya Burke on 1/22/20.
//  Copyright © 2020 Tanya Burke. All rights reserved.
//


import Foundation
import NetworkHelper

struct PhotoAPIClient {
    static func getPhotos(with query: String, completion: @escaping (Result<[Photo], AppError>)->()){
        let editedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "beauty"
       
        let endPointURLString = "https://pixabay.com/api/?key=\(key)&q=\(editedQuery)=photo"
        
        guard let url = URL(string: endPointURLString) else {
            completion(.failure(.badURL(endPointURLString)))
            return
        }
        
        let request = URLRequest(url: url)
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result{
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do{
                    let photoData = try JSONDecoder().decode(PhotoData.self, from: data)
                    let photo = photoData.hits
                    completion(.success(photo))
                } catch{
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
}
