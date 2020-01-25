//
//  TableTableViewController.swift
//  ToDoList.1
//
//  Created by Evgeniy on 08.01.2020.
//  Copyright © 2020 Evgeniy Polyanskiy. All rights reserved.
//

import UIKit

class TableTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Убераем не нужные линии
        tableView.tableFooterView = UIView()
        //меняем цвет бэка
        tableView.backgroundColor = UIColor.groupTableViewBackground
       
    }
    
    @IBAction func pushEditAction(_ sender: Any) {
        //MARK: - Режим редактирования таблицы(2)
        tableView.setEditing(!tableView.isEditing, animated: true)
        //Выполнить блок кода в основном потоке спустя некоторого кол времени
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.tableView.reloadData()

        }
    }
    //Добавить элемент
    @IBAction func addItem(_ sender: Any) {
        //add UIAlertController
        let alertController = UIAlertController(title: "Create new task", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "New item name"
        }
        let alertAction1 = UIAlertAction(title: "Cancel", style: .default) { (alert) in
            
        }
        let alertAction2 = UIAlertAction(title: "Create", style: .cancel) { (alert) in
            //add new note
            let newItem = alertController.textFields![0].text
            if newItem != ""{
                ToDoList_1.addItem(nameItem: newItem!)
                self.tableView.reloadData()
                
            }
    
        }
        alertController.addAction(alertAction1)
        alertController.addAction(alertAction2)

        present(alertController, animated: true, completion: nil)
    }


    // MARK: - Table view data source

    //кол разделов
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    //количество рядов в разделе = кол эл в массиве
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoItems.count
    }

    //ячейка 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //переменная currentItem наш словарь
        let currentItem = toDoItems[indexPath.row]
        cell.textLabel?.text = currentItem["Name"] as? String
        
        //Теперь нам нужно получить значение из словаря по ключу
        if (currentItem["isCompleted"] as? Bool) == true{
            //Добавим галочку для успешно выполненных заданий
            cell.imageView?.image = #imageLiteral(resourceName: "check")
        }else {
            cell.imageView?.image = #imageLiteral(resourceName: "unCheck")
        }
        
        //Это нам для того чтобы в режиме редактирования наши заметки стали более прозрачными
        if tableView.isEditing{
            cell.textLabel?.alpha = 0.4
            cell.imageView?.alpha = 0.4
        }else {
            cell.textLabel?.alpha = 1
            cell.imageView?.alpha = 1
        }
        return cell
    }
    
    
    // Воспользуемся этим методом для удаления записей
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    // Этот метод слева выводит красную панель для удаления
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //Сдесь допишем наш метод для удаления во избежания ошибки
            removeItem(at: indexPath.row)
    
            tableView.deleteRows(at: [indexPath], with: .fade)
        }else if editingStyle == .insert {
            
        }    
    }
    
    //MARK: - Обрабатываем нажатие
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if changeState(at: indexPath.row){
            tableView.cellForRow(at: indexPath)?.imageView?.image = #imageLiteral(resourceName: "check")
        }else {
            tableView.cellForRow(at: indexPath)?.imageView?.image = #imageLiteral(resourceName: "unCheck")
        }
        
    }
    

    //Меняет записи местами, чтоб это было осуществимо, нам нужно чтобы таблица была в
    //MARK: - режиме редактирования(1)
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        moveItem(fromIndex: fromIndexPath.row, toIndex: to.row)
        tableView.reloadData() //обновим нашу таблицу

    }
    
    //Два метода редактируем стиль
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing{
            return .none
        }else {
            return .delete
        }
        
    }
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

}
