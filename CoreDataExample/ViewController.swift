//
//  ViewController.swift
//  CoreDataExample
//
//  Created by Akanksha pakhale on 18/10/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource,UITabBarDelegate, UITableViewDelegate {
    //For Core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //initialise table View
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
       title = "ToDo List"
        //Calling All data
        getAllItems()
        view.addSubview(tableView)
        //Confirming Delegates
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.bounds
        //setting add Button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    //Action on add tap
    @objc private func didTapAdd(){
        let alert = UIAlertController(title: "New item", message: "Enter new Item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "submit", style: .cancel, handler: { [weak self] _ in
            guard let field = alert.textFields?.first,
                  let text = field.text, !text.isEmpty else {
                return
            }
            self?.createItem(name: text)
        }))
        present(alert,animated: true)
    }
    //Array of all items
    private var models = [TodoListItem]()
    //table view rows count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    //table view row data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.name
        return cell
    }
    //Action on row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = models[indexPath.row]
        
        let sheet = UIAlertController(title: "Actions", message: nil, preferredStyle: .actionSheet)
        
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            
            let alert = UIAlertController(title: "Edit item ", message: "Edit your Items", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.name
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
                guard let field = alert.textFields?.first,
                      let newName = field.text, !newName.isEmpty else {
                    return
                }
                self?.updateItem(item: item, newName: newName)
            }))
            self.present(alert,animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteItem(item: item)
        }))
        present(sheet,animated: true)
    }
    //get data function
    func getAllItems(){
        do {
        models = try context.fetch(TodoListItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            }
        catch{
            //error
        }
    }
    func createItem(name: String){
        let newItem = TodoListItem(context: context)
        newItem.name = name
        newItem.date = Date()
      do {
        try context.save()
        getAllItems()
        }
      catch{
        
      }
    }
    func deleteItem(item: TodoListItem){
        context.delete(item)
        do {
          try context.save()
            getAllItems()
          }
        catch{
            //error
        }
    }
    func updateItem(item: TodoListItem, newName: String){
        item.name = newName
        do {
          try context.save()
            getAllItems()
          }
        catch{
          //error
        }
    }
}

