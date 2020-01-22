//
//  FavoritesViewController.swift
//  PersistenceLab
//
//  Created by Tanya Burke on 1/21/20.
//  Copyright © 2020 Tanya Burke. All rights reserved.

import UIKit
import ImageKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var refreshControl: UIRefreshControl!
    
    private var favorites = [Photo](){
        didSet{
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        configureRefreshControl()
        delegatesAndDataSources()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailsVC = segue.destination as? DetailsViewController, let indexPath = tableView.indexPathForSelectedRow else {
            fatalError("failed to segue")
        }
        let favorite = favorites[indexPath.row]
        detailsVC.passedObj = favorite
    }
    
    func configureRefreshControl(){
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    func delegatesAndDataSources(){
        tableView.dataSource = self
    }
    
    @objc
    func loadData(){
        do {
            try favorites = PersistanceHelper.load()
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        } catch {
            self.showAlert(title: "Failed to load data", message: "\(error)")
            self.refreshControl.endRefreshing()
        }
    }

    private func deleteFavorite(indexPath: IndexPath){
        do{
            try PersistanceHelper.delete(photo: indexPath.row)
        } catch {
            self.showAlert(title: "Failed to delate", message: "\(error)")
        }
    }

}

extension FavoritesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      switch editingStyle {
      case .insert:
        // only gets called if "insertion control" exist and gets selected
        print("inserting....")
      case .delete:
        print("deleting..")
        // 1. remove item for the data model e.g events
        favorites.remove(at: indexPath.row) // remove event from events array
        
        deleteFavorite(indexPath: indexPath)
        // 2. update the table view
        tableView.deleteRows(at: [indexPath], with: .automatic)
          
      default:
        print("......")
      }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)
        let favorite = favorites[indexPath.row]
        cell.textLabel?.text = "Id: \(favorite.id)"
        cell.detailTextLabel?.text = "User: \(favorite.user)"
        cell.imageView?.getImage(with: favorite.previewURL, completion: { [weak cell](result) in
            switch result{
            case .failure:
                DispatchQueue.main.async {
                    cell?.imageView?.image = UIImage(systemName: "exclaimationmark-triangle")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    cell?.imageView?.image = image
                    tableView.reloadData()
                }
            }
        })
        return cell
    }
    
    
}
