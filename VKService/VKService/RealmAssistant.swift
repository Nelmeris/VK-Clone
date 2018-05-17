//
//  RealmAssistant.swift
//  VKService
//
//  Created by Артем on 17.05.2018.
//  Copyright © 2018 Nelmeris. All rights reserved.
//

import RealmSwift

// Сохранение данных в Realm
public func SaveData<Type: BaseModel>(_ data: [Type]) {
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
public func UpdatingData<Type: BaseModel>(_ data: [Type]) {
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

// Загрузка данных из Realm
public func LoadData<Type: BaseModel>() -> Results<Type>? {
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
public func ClearData<Type: BaseModel>(_ data: [Type]) {
    do {
        let realm = try Realm()
        realm.beginWrite()
        realm.delete(realm.objects(Type.self))
        try realm.commitWrite()
    } catch let error {
        print(error)
    }
}

// Удаление поля в Realm
//public func DeleteData<Type: Models>(_ data: [Type]) {
//    do {
//        let realm = try Realm()
//        realm.beginWrite()
//        realm.add(data)
//        try realm.commitWrite()
//    } catch let error {
//        print(error)
//    }
//}
