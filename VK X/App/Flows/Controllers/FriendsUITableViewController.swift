//
//  FriendsUITableViewController.swift
//  VK X
//
//  Created by Artem Kufaev on 01.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import RealmSwift

class FriendsUITableViewController: UITableViewController, UISearchResultsUpdating {
  var friends: Results<VKUserModel>!
  var filteredFriends: Results<VKUserModel>!

  var notificationToken: NotificationToken!

  var searchController = UISearchController(searchResultsController: nil)

  override func viewDidLoad() {
    super.viewDidLoad()

    initSearchController()

    friends = RealmService.shared.loadData()!
    filteredFriends = friends

    RealmService.shared.pairTableViewAndData(sender: tableView, token: &notificationToken, data: AnyRealmCollection(friends))
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    VKService.Methods.Friends.get { data in
      RealmService.shared.updateData(data)
    }
  }

  func initSearchController() {
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Искать..."

    searchController.searchBar.isTranslucent = false

    navigationItem.searchController = searchController

    definesPresentationContext = true
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return friends.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let friend = friends[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "Friend") as! FriendsUITableViewCell

    cell.name.text = friend.firstName + " " + friend.lastName

    cell.setPhoto(friend.photo)
    cell.onlineStatusIcon.initial(friend.isOnline, friend.isOnlineMobile, cell.photo.frame, tableView.backgroundColor!)

    return cell
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let viewController = segue.destination as! FriendPhotosUIViewController
    guard let indexPath = self.tableView.indexPathForSelectedRow else { return }

    viewController.user = (RealmService.shared.loadData()! as Results<VKUserModel>)[indexPath.row]
  }

  func updateSearchResults(for searchController: UISearchController) {
    guard searchController.searchBar.text != "" else {
      friends = filteredFriends
      tableView.reloadData()
      return
    }

    let searchText = searchController.searchBar.text!
    let array = searchText.components(separatedBy: " ")

    let predicate = array.count > 1 && array[1] != "" ?
      "(firstName CONTAINS[cd] '\(array.first!)' AND lastName CONTAINS[cd] '\(array[1])') OR (firstName CONTAINS[cd] '\(array[1])' AND lastName CONTAINS[cd] '\(array.first!)')" :
    "firstName CONTAINS[cd] '\(array.first!)' OR lastName CONTAINS[cd] '\(array.first!)'"

    friends = filteredFriends.filter(predicate)

    tableView.reloadData()
  }
}
