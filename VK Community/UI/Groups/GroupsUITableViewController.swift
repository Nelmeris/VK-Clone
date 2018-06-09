//
//  GroupsUITableViewController.swift
//  VK Community
//
//  Created by Артем on 03.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import RealmSwift

class GroupsUITableViewController: UITableViewController, UISearchResultsUpdating {
    
    var groups: Results<VKGroupModel>!
    var filteredGroups: Results<VKGroupModel>!
    
    var notificationToken: NotificationToken!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        VKService.request(method: "groups.get", parameters: ["extended" : "1"]) { (response: VKItemsModel<VKGroupModel>) in
            RealmService.updateData(response.items)
        }
    }
    
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 75
        
        initSearchController()
        
        groups = RealmService.loadData()
        filteredGroups = groups
        
        RealmService.pairTableViewAndData(sender: tableView, token: &notificationToken, data: AnyRealmCollection(groups))
    }
    
    func initSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Искать..."
        
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = groups[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroup", for: indexPath) as! GroupsUITableViewCell

        cell.name.text = group.name
        
        setGroupPhoto(cell: cell, group: group)

        return cell
    }

    @IBAction func JoinGroup(_ sender: UIStoryboardSegue) {
        let allGroupsController = sender.source as! GroupsSearchUITableViewController
        let index = allGroupsController.tableView.indexPathForSelectedRow!.row
        let group = allGroupsController.groups[index]
        
        VKService.request(method: "groups.join", parameters: ["group_id" : String(group.id)]) { _ in
            VKService.request(method: "groups.get", parameters: ["extended" : "1"]) { (response: VKItemsModel<VKGroupModel>) in
                RealmService.updateData(response.items)
            }
        }
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Покинуть") { (action, indexPath) in
            let alert = UIAlertController(title: "Вы уверены, что хотите покинуть \"\(self.groups![indexPath.row].name)\"?", message: nil, preferredStyle: .actionSheet)
            var action = UIAlertAction(title: "Отмена", style: .cancel)
            alert.addAction(action)

            action = UIAlertAction(title: "Покинуть", style: .destructive) { (action) in
                VKService.request(method: "groups.leave", parameters: ["group_id" : String(self.groups![indexPath.row].id)]) { _ in
                    VKService.request(method: "groups.get", parameters: ["extended" : "1"]) { (response: VKItemsModel<VKGroupModel>) in
                        RealmService.updateData(response.items)
                    }
                }
            }
            alert.addAction(action)

            self.present(alert, animated: true, completion: nil)
        }
        return [deleteAction]
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.searchBar.text != "" else {
            groups = filteredGroups
            tableView.reloadData()
            return
        }
        
        let searchText = searchController.searchBar.text!
        
        let predicate = "name contains[cd] '\(searchText)'"
        
        groups = filteredGroups.filter(predicate)
        
        tableView.reloadData()
    }
    
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()

}

extension GroupsUITableViewController {
    
    func setGroupPhoto(cell: GroupsUITableViewCell, group: VKGroupModel) {
        guard group.photo100 != "" else { return }
        
        let getCacheImageOperation = GetCacheImage(url: group.photo100)
        
        getCacheImageOperation.completionBlock = {
            OperationQueue.main.addOperation {
                cell.photo.image = getCacheImageOperation.outputImage
            }
        }
        
        queue.addOperation(getCacheImageOperation)
    }
    
}

class SetImageToGroupsRow: Operation {
    private let indexPath: IndexPath
    private weak var tableView: UITableView?
    private var cell: GroupsUITableViewCell?
    
    init(cell: GroupsUITableViewCell, indexPath: IndexPath, tableView: UITableView) {
        self.indexPath = indexPath
        self.tableView = tableView
        self.cell = cell
    }
    
    override func main() {
        guard let tableView = tableView,
            let cell = cell,
            let getCacheImage = dependencies[0] as? GetCacheImage,
            let image = getCacheImage.outputImage else { return }
        
        if let newIndexPath = tableView.indexPath(for: cell), newIndexPath == indexPath {
            cell.photo.image = image
        } else if tableView.indexPath(for: cell) == nil {
            cell.photo.image = image
        }
    }
}
