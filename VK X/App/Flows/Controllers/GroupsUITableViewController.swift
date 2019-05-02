//
//  GroupsUITableViewController.swift
//  VK X
//
//  Created by Artem Kufaev on 03.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import RealmSwift

class GroupsUITableViewController: UITableViewController, UISearchResultsUpdating {
  var groups: Results<VKGroupModel>!
  var filteredGroups: Results<VKGroupModel>!

  var notificationToken: NotificationToken!

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    VKService.Methods.Groups.get { data in
      RealmService.shared.updateData(data)
    }
  }

  var searchController = UISearchController(searchResultsController: nil)

  override func viewDidLoad() {
    super.viewDidLoad()

    initSearchController()

    groups = RealmService.shared.loadData()
    filteredGroups = groups

    RealmService.shared.pairTableViewAndData(sender: tableView, token: &notificationToken, data: AnyRealmCollection(groups))
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

    cell.setPhoto(group.photo)

    return cell
  }

  @IBAction func JoinGroup(_ sender: UIStoryboardSegue) {
    let allGroupsController = sender.source as! GroupsSearchUITableViewController
    let index = allGroupsController.tableView.indexPathForSelectedRow!.row
    let group = allGroupsController.groups[index]

    VKService.Methods.Groups.join(groupId: group.id) {
      VKService.Methods.Groups.get { data in
        RealmService.shared.updateData(data)
      }
    }
  }

  override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let deleteAction = UITableViewRowAction(style: .default, title: "Покинуть") { [weak self] (action, indexPath) in
      guard let strongSelf = self else { return }

      let alert = UIAlertController(title: "Вы уверены, что хотите покинуть \"\(strongSelf.groups[indexPath.row].name)\"?", message: nil, preferredStyle: .actionSheet)
      var action = UIAlertAction(title: "Отмена", style: .cancel)
      alert.addAction(action)

      action = UIAlertAction(title: "Покинуть", style: .destructive) { _ in
        VKService.Methods.Groups.leave(groupId: strongSelf.groups[indexPath.row].id) {
          VKService.Methods.Groups.get { data in
            RealmService.shared.updateData(data)
          }
        }
      }
      alert.addAction(action)

      strongSelf.present(alert, animated: true, completion: nil)
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
}

class SetImageToGroupsRow: Operation {
  private let indexPath: IndexPath
  private weak var tableView: UITableView?
  private var cell: GroupsUITableViewCell?

  init(_ cell: GroupsUITableViewCell, _ indexPath: IndexPath, _ tableView: UITableView) {
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
