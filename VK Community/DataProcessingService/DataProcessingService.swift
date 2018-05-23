//
//  RealmAssistant.swift
//  VKService
//
//  Created by Артем on 17.05.2018.
//  Copyright © 2018 Nelmeris. All rights reserved.
//

import RealmSwift
import UIKit

// Сохранение данных в Realm
public func SaveData<Type: DataBaseModel>(_ data: [Type]) {
    do {
        let realm = try Realm()
        realm.beginWrite()
        realm.add(data)
        try realm.commitWrite()
    } catch let error {
        print(error)
    }
}

// Обновление данных в Realm
public func UpdatingData<Type: DataBaseModel>(_ data: [Type]) {
    do {
        let realm = try Realm()
        
        realm.beginWrite()
        
        // Удаление элементов
        var delete = realm.objects(Type.self)
        for item in data {
            delete = delete.filter("id != %@", item.value(forKey: "id") as! Int)
        }
        realm.delete(delete)
        
        // Игнорирование не измененных элементов
        var data = data
        for item1 in data {
            for item2 in realm.objects(Type.self) {
                if item1.isEqual(item2) {
                    data.remove(at: data.index(of: item1)!)
                }
            }
        }
        
        realm.add(data, update: true)
        try realm.commitWrite()
    } catch let error {
        print(error)
    }
}

// Загрузка данных из Realm
public func LoadData<Type: DataBaseModel>() -> Results<Type>? {
    do {
        let realm = try Realm()
        return realm.objects(Type.self)
    } catch let error {
        print(error)
        return nil
    }
}

// Очистка базы Realm
public func ClearDataBase() {
    do {
        let realm = try Realm()
        realm.beginWrite()
        realm.deleteAll()
        try realm.commitWrite()
    } catch let error {
        print(error)
    }
}

// Очистка данных в Realm
public func ClearData<Type: DataBaseModel>(_ data: [Type]) {
    do {
        let realm = try Realm()
        realm.beginWrite()
        realm.delete(realm.objects(Type.self))
        try realm.commitWrite()
    } catch let error {
        print(error)
    }
}

public func DeleteData<Type: DataBaseModel>(_ data: [Type]) {
    do {
        let realm = try Realm()
        realm.beginWrite()
        realm.delete(data)
        try realm.commitWrite()
    } catch let error {
        print(error)
    }
}

public func PairTableAndData<Type: DataBaseModel>(sender: UITableView, token: inout NotificationToken?, data: AnyRealmCollection<Type>) {
    token = data.observe { (changes: RealmCollectionChange) in
        switch changes {
        case .initial:
            sender.reloadData()
            break

        case .update(_, let deletions, let insertions, let modifications):
            sender.beginUpdates()
            sender.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
            sender.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
            sender.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .none)
            sender.endUpdates()
            break

        case .error(let error):
            fatalError(error.localizedDescription)
            break
        }
    }
}

public func PairCollectionAndData<Type: DataBaseModel>(sender: UICollectionView, token: inout NotificationToken?, data: AnyRealmCollection<Type>) {
    token = data.observe { (changes: RealmCollectionChange) in
        switch changes {
        case .initial:
            sender.reloadData()
            break
            
        case .update(_, let deletions, let insertions, let modifications):
            sender.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
            sender.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0) }))
            sender.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0) }))
            break
            
        case .error(let error):
            fatalError(error.localizedDescription)
            break
        }
    }
}
