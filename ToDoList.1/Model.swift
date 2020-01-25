//
//  Model.swift
//  ToDoList.1
//
//  Created by Evgeniy on 08.01.2020.
//  Copyright © 2020 Evgeniy Polyanskiy. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

var toDoItems : [[String : Any]] {
    set{
        //MARK: - UserDefaults
        //For save data we used UserDefaults
        UserDefaults.standard.set(newValue, forKey: "ToDoDataKey")
        UserDefaults.standard.synchronize()
    }
    get{
        //Делаем проверку и приведение так как нам тут прийдёт массив [String]
        if let array = UserDefaults.standard.array(forKey: "ToDoDataKey") as? [[String : Any]]{
           return array
        }else {
            //В противном случае он будет пустым
            return  []
        }
        
    }
}

func addItem(nameItem: String, isCompleted: Bool = false){
    toDoItems.append(["Name": nameItem, "isCompleted": isCompleted])
    setBadge()
}

func removeItem(at index: Int){
    toDoItems.remove(at: index)
    setBadge()
    
}
func moveItem(fromIndex: Int, toIndex: Int){
    //Это всё мы делаем для того чтобы перемешать элементы местами и сохранять их положение
    let from = toDoItems[fromIndex] //сохраняем элемент from
    toDoItems.remove(at: fromIndex) //удалим по индексу fromIndexPath
    toDoItems.insert(from, at: toIndex) // добавим
}

//Изменить состояние объекта
func changeState(at item: Int) -> Bool{
   toDoItems[item]["isCompleted"] = !(toDoItems[item]["isCompleted"] as! Bool)
   //вызываем метод нашего бэйджа
    setBadge()
    return toDoItems[item]["isCompleted"] as! Bool
}

//MARK: - Our Notification
//Зарос на уведомления
//Для этого нам понадобиться фреймворк UserNotifications
func requestForNotification(){
    //там где options указываем массив с типом нотификации которые мы будем отображать
    UNUserNotificationCenter.current().requestAuthorization(options: [.badge]) { (isEnabled, error) in
        if isEnabled {
            print("Разрешение получено")
        }else {
            print("Отказ")
        }
    }
}

//MARK:- Badge
//Нужем метод для установки Бэйджа
func setBadge(){
    
    var totalBadgeNumber = 0
    for item in toDoItems{
       if item["isCompleted"] as? Bool == false{
            totalBadgeNumber += 1
        }
        
    }
    //Подключаем UIKit и через него устанавливаем делегат
    UIApplication.shared.applicationIconBadgeNumber = totalBadgeNumber
}
