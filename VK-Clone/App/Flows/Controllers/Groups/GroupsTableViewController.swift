//
//  GroupsTableViewController.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 03.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit

class GroupsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var displayedGroups = [VKGroupModel]()
    var groups = [VKGroupModel]()
    
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        self.tableView.rowHeight = 55.0
        
        VKService.shared.getGroups { [weak self] newGroups in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.displayedGroups = newGroups
                strongSelf.groups = newGroups
                strongSelf.tableView.reloadData()
            }
        }
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Искать..."
        
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        VKService.shared.getGroups { [weak self] newGroups in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.tableView.beginUpdates()
                strongSelf.tableView.updateData(data: strongSelf.groups, newData: newGroups)
                strongSelf.displayedGroups = newGroups
                strongSelf.groups = newGroups
                strongSelf.tableView.endUpdates()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = displayedGroups[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroup", for: indexPath) as! GroupsTableViewCell
        
        cell.name.text = group.name
        
        cell.setPhoto(group.avatar.photo100.absoluteString)
        
        return cell
    }
    
    @IBAction func JoinGroup(_ sender: UIStoryboardSegue) {
        let controller = sender.source as! GroupsSearchTableViewController
        let index = controller.tableView.indexPathForSelectedRow!.row
        let group = controller.groups[index]
        
        VKService.shared.joinGroup(groupId: group.id) { _ in
            VKService.shared.getGroups { [weak self] newGroups in
                guard let strongSelf = self else { return }
                DispatchQueue.main.async {
                    strongSelf.tableView.beginUpdates()
                    strongSelf.tableView.updateData(data: strongSelf.groups, newData: newGroups)
                    strongSelf.displayedGroups = newGroups
                    strongSelf.groups = newGroups
                    strongSelf.tableView.endUpdates()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Покинуть") { [weak self] (action, indexPath) in
            guard let strongSelf = self else { return }
            
            let alert = UIAlertController(title: "Вы уверены, что хотите покинуть \"\(strongSelf.displayedGroups[indexPath.row].name)\"?", message: nil, preferredStyle: .actionSheet)
            var action = UIAlertAction(title: "Отмена", style: .cancel)
            alert.addAction(action)
            
            action = UIAlertAction(title: "Покинуть", style: .destructive) { action in
                VKService.shared.leaveGroup(groupId: strongSelf.displayedGroups[indexPath.row].id) { _ in
                    VKService.shared.getGroups { [weak self] newGroups in
                        guard let strongSelf = self else { return }
                        DispatchQueue.main.async {
                            strongSelf.tableView.beginUpdates()
                            strongSelf.tableView.updateData(data: strongSelf.groups, newData: newGroups)
                            strongSelf.displayedGroups = newGroups
                            strongSelf.groups = newGroups
                            strongSelf.tableView.endUpdates()
                        }
                    }
                }
            }
            alert.addAction(action)
            
            strongSelf.present(alert, animated: true, completion: nil)
        }
        return [deleteAction]
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text,
            !searchText.isEmpty else {
            self.tableView.beginUpdates()
            self.tableView.updateData(data: self.displayedGroups, newData: self.groups, with: .none)
            displayedGroups = groups
            self.tableView.endUpdates()
            return
        }
        
        self.tableView.beginUpdates()
        let oldGroups = displayedGroups
        displayedGroups = groups.filter({ group -> Bool in
            return group.name.lowercased().contains(searchText.lowercased())
        })
        self.tableView.updateData(data: oldGroups, newData: displayedGroups, with: .none)
        self.tableView.endUpdates()
    }
}

class SetImageToGroupsRow: Operation {
    private let indexPath: IndexPath
    private weak var tableView: UITableView?
    private var cell: GroupsTableViewCell?
    
    init(_ cell: GroupsTableViewCell, _ indexPath: IndexPath, _ tableView: UITableView) {
        self.indexPath = indexPath
        self.tableView = tableView
        self.cell = cell
    }
    
    override func main() {
        guard let tableView = tableView,
            let cell = cell,
            let getCacheImage = dependencies.first as? GetCacheImage,
            let image = getCacheImage.outputImage else { return }
        
        guard let newIndexPath = tableView.indexPath(for: cell), newIndexPath == indexPath ||
            tableView.indexPath(for: cell) == nil else { return }
        
        cell.photo.image = image
    }
}
