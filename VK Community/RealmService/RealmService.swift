//
//  RealmService.swift
//  VK Community
//
//  Created by Артем on 17.05.2018.
//  Copyright © 2018 Nelmeris. All rights reserved.
//

import RealmSwift

class RealmService {
    
    // Сохранение данных в Realm
    static func resaveData<Type: RealmModel>(_ data: [Type]) {
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
    
    // Обновление данных в Realm
    static func updateData<Type: RealmModel>(_ data: [Type]) {
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
                        break
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
    static func loadData<Type: RealmModel>() -> Results<Type>? {
        do {
            let realm = try Realm()
            return realm.objects(Type.self)
        } catch let error {
            print(error)
            return nil
        }
    }
    
    // Очистка базы Realm
    static func clearDataBase() {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.deleteAll()
            try realm.commitWrite()
        } catch let error {
            print(error)
        }
    }
    
    // Очистка данных Realm
    static func clearData<Type: RealmModel>(_ data: [Type]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.delete(realm.objects(Type.self))
            try realm.commitWrite()
        } catch let error {
            print(error)
        }
    }
    
    // Удаление данных из Realm
    static func deleteData<Type: RealmModel>(_ data: [Type]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.delete(data)
            try realm.commitWrite()
        } catch let error {
            print(error)
        }
    }
    
}
