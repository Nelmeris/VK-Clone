//
//  RealmAssistant.swift
//  VKService
//
//  Created by Артем on 17.05.2018.
//  Copyright © 2018 Nelmeris. All rights reserved.
//

import RealmSwift

// Сохранение данных в Realm
func RealmSaveData<Type: DataBaseModel>(_ data: [Type]) {
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
func RealmUpdateData<Type: DataBaseModel>(_ data: [Type]) {
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
func RealmLoadData<Type: DataBaseModel>() -> Results<Type>? {
    do {
        let realm = try Realm()
        return realm.objects(Type.self)
    } catch let error {
        print(error)
        return nil
    }
}

// Очистка базы Realm
func RealmClearDataBase() {
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
func RealmClearData<Type: DataBaseModel>(_ data: [Type]) {
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
func RealmDeleteData<Type: DataBaseModel>(_ data: [Type]) {
    do {
        let realm = try Realm()
        realm.beginWrite()
        realm.delete(data)
        try realm.commitWrite()
    } catch let error {
        print(error)
    }
}
