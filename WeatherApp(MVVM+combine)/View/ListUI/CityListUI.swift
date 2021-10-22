//
//  ViewController.swift
//  WeatherApp(MVVM+combine)
//
//  Created by Sergey on 12.10.2021.
//

import UIKit
import Combine



class CityListUI: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    var VM: CityListVM!
    
    @IBOutlet weak var citiesTable: UITableView!
    @IBOutlet weak var cityNameTextField: UITextField!
    
    @IBAction func addCityPressed(_ sender: UIButton) {
        let name = cityNameTextField.text ?? ""
        
        guard name != "" else {
            messageBox(title: "Внимание", message: "Некорректное название города", actionTitle: "OK", comment: "Default action", logMessage: "The city name is empty")
            return
        }
        
        if !VM.addCity(name: name){
            messageBox(title: "Внимание", message: "Название города дублируется", actionTitle: "OK", comment: "Default action", logMessage: "The city name is incorrect")
        }
    }
    
    
    var cityAddCancellable: Cancellable? = nil
    var VMCancellable: Cancellable? = nil
    
    let cellReuseIdentifier = "customCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.citiesTable.delegate = self
        self.citiesTable.dataSource = self
        citiesTable.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        
        
        VM = .init(model: wetherSingleton)
        VMCancellable = VM?
            .objectWillChange
            .sink(receiveValue: { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    if self != nil{
                        let currentCount = self!.citiesTable.numberOfRows(inSection: 0)
                        let toInsert = self!.VM!.cityWhetherList.count - currentCount
                        
                        self?.citiesTable.beginUpdates()
                        
                        if toInsert > 0{
                            self?.citiesTable.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
                        }
                        else if toInsert < 0{
                            self?.citiesTable.deleteRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
                        }
                        self?.citiesTable.endUpdates()
                    }
                }
            })
        
        cityAddCancellable = VM?.$cityAddFailed.sink{_ in 
            DispatchQueue.main.async { [weak self] in
                self?.messageBox(title: "Внимание", message: "Название города некорректно", actionTitle: "OK", comment: "Default action", logMessage: "The city name is incorrect")
            }
        }
        
        citiesTable.reloadData()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.VM?.cityWhetherList.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier)! as! TableViewCell
        cell.labelCityName.text = VM.cityWhetherList[indexPath.row].name
        cell.labelCityTemp.text = VM.cityWhetherList[indexPath.row].temp
        cell.imageViewCell.image = UIImage.init(named: VM.cityWhetherList[indexPath.row].iconName)
       
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cityWhetherDetail", sender: tableView.cellForRow(at: indexPath))
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteCity = UIContextualAction(style: .destructive, title: "Удалить") { action, view, success in
            self.citiesTable.reloadData()
            print(self.VM.cityWhetherList.count)
            print(self.citiesTable.numberOfSections)
            DispatchQueue.main.async {
                self.VM.cityWhetherList[indexPath.row].deleteWeatherCity()
            }
        }
        let conf = UISwipeActionsConfiguration(actions: [deleteCity])
        conf.performsFirstActionWithFullSwipe = false
        return conf
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell {
            let selectedIndex = self.citiesTable.indexPath(for: cell)!.row
            if segue.identifier == "cityWhetherDetail" {
                let vc = segue.destination as! CityWhetherDetail
                vc.VM = VM?.cityWhetherList[selectedIndex]
            }
        }
    }
}
