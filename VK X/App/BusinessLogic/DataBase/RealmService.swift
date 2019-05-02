//
//  RealmService.swift
//  VK X
//
//  Created by Artem Kufaev on 17.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import RealmSwift

class RealmService {
  private init() {}

  static let shared = RealmService()

  func resaveData<Type: RealmModel>(_ data: [Type]) {
    do {
      let realm = try Realm()
      realm.beginWrite()
      realm.delete(realm.objects(Type.self))
      realm.add(data)
      try realm.commitWrite()
    } catch let error {
      print(error)
    }
  }

  func updateData<Type: RealmModel>(_ data: [Type]) {
    do {
      let realm = try Realm()

      realm.beginWrite()

      // Удаляем из БД элементы, которые отсутствуют в полученных данных
      var delete = realm.objects(Type.self)
      for data in data {
        delete = delete.filter("id != %@", data.value(forKey: "id") as! Int)
      }
      realm.delete(delete)

      // Удаляем из полученных данных элементы, которые уже есть в БД
      var data = data

      for newData in data {
        for oldData in realm.objects(Type.self) {
          guard newData.isEqual(oldData) else { continue }

          data.remove(at: data.index(of: newData)!)
          break
        }
      }

      realm.add(data, update: true)
      try realm.commitWrite()
    } catch let error {
      print(error)
    }
  }

  func loadData<Type: RealmModel>(keyForSort: String? = nil) -> Results<Type>? {
    do {
      let realm = try Realm()
      if let key = keyForSort {
        return realm.objects(Type.self).sorted(byKeyPath: key, ascending: false)
      } else {
        return realm.objects(Type.self)
      }
    } catch let error {
      print(error)
      return nil
    }
  }

  func clearDataBase() {
    do {
      let realm = try Realm()
      realm.beginWrite()
      realm.deleteAll()
      try realm.commitWrite()
    } catch let error {
      print(error)
    }
  }

  func clearData<Type: RealmModel>(_ data: [Type]) {
    do {
      let realm = try Realm()
      realm.beginWrite()
      realm.delete(realm.objects(Type.self))
      try realm.commitWrite()
    } catch let error {
      print(error)
    }
  }

  func deleteData<Type: RealmModel>(_ data: [Type]) {
    do {
      let realm = try Realm()
      realm.beginWrite()
      realm.delete(data)
      try realm.commitWrite()
    } catch let error {
      print(error)
    }
  }

  func getFileURL() -> URL? {
    do {
      let realm = try Realm()
      return realm.configuration.fileURL
    } catch let error {
      print(error)
      return nil
    }
  }
}
