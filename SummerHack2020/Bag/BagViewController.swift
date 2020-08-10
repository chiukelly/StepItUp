//
//  BagViewController.swift
//  SummerHack2020
//
//  Created by Natalie Wang on 8/6/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

class BagViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    
    var shirt_models = [bagModelStore]()
    var pant_models = [bagModelStore]()
    var shoe_models = [bagModelStore]()
    var hair_models = [bagModelStore]()
    var worn_items: [bagModelStore] = [nil, nil, nil, nil, nil]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBagData()
        
        table.register(BagCollectionTableViewCell.nib(), forCellReuseIdentifier: BagCollectionTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        table.isScrollEnabled = false;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: BagCollectionTableViewCell.identifier, for: indexPath) as! BagCollectionTableViewCell
        if indexPath.row == 0 {
            cell.configure(with: shirt_models)
        } else if indexPath.row == 1 {
            cell.configure(with: pant_models)
        } else if indexPath.row == 2 {
            cell.configure(with: shoe_models)
        } else {
            cell.configure(with: hair_models)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    private func getBagData() {
        // load user data
        let url = URL(string: "http://127.0.0.1:5000/get-unworn-bag-data")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.multipartFormData(parameters: ["user_id": "\(UserDefaults.standard.integer(forKey: defaultsKeys.userIdKey))"])
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let tempBagData = try JSONDecoder().decode(bagModelArray.self, from: data)
                for tempItem in tempBagData.results {
                    let tempItemTwo = bagModelStore(name: tempItem.name, category: tempItem.category, id: tempItem.id, selected: false)
                    if tempItemTwo.category == 1 {
                        self.shirt_models.append(bagModelStore(name: tempItemTwo.name, category: tempItemTwo.category, id: tempItemTwo.id, selected: tempItemTwo.selected))
                    }
                    if tempItemTwo.category == 2 {
                        self.pant_models.append(bagModelStore(name: tempItemTwo.name, category: tempItemTwo.category, id: tempItemTwo.id, selected: tempItemTwo.selected))
                    }
                    if tempItemTwo.category == 3 {
                        self.shoe_models.append(bagModelStore(name: tempItemTwo.name, category: tempItemTwo.category, id: tempItemTwo.id, selected: tempItemTwo.selected))
                    }
                    if tempItemTwo.category == 4 {
                        self.hair_models.append(bagModelStore(name: tempItemTwo.name, category: tempItemTwo.category, id: tempItemTwo.id, selected: tempItemTwo.selected))
                    }
                }
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            } catch let jsonErr {
                print(jsonErr)
            }
        }
        task.resume()
    }
    
    private func getBagData() {
        // load user data
        let url = URL(string: "http://127.0.0.1:5000/get-worn-bag-data")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.multipartFormData(parameters: ["user_id": "\(UserDefaults.standard.integer(forKey: defaultsKeys.userIdKey))"])
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let tempBagData = try JSONDecoder().decode(bagModelArray.self, from: data)
                for tempItem in tempBagData.results {
                    let tempItemTwo = bagModelStore(name: tempItem.name, category: tempItem.category, id: tempItem.id, selected: true)
                    if tempItemTwo.category == 1 {
                        self.shirt_models.append(bagModelStore(name: tempItemTwo.name, category: tempItemTwo.category, id: tempItemTwo.id, selected: tempItemTwo.selected))
                        self.worn_items[1] = bagModelStore(name: tempItemTwo.name, category: tempItemTwo.category, id: tempItemTwo.id, selected: tempItemTwo.selected)
                    }
                    if tempItemTwo.category == 2 {
                        self.pant_models.append(bagModelStore(name: tempItemTwo.name, category: tempItemTwo.category, id: tempItemTwo.id, selected: tempItemTwo.selected))
                        self.worn_items[2] = bagModelStore(name: tempItemTwo.name, category: tempItemTwo.category, id: tempItemTwo.id, selected: tempItemTwo.selected)
                    }
                    if tempItemTwo.category == 3 {
                        self.shoe_models.append(bagModelStore(name: tempItemTwo.name, category: tempItemTwo.category, id: tempItemTwo.id, selected: tempItemTwo.selected))
                        self.worn_items[3] = bagModelStore(name: tempItemTwo.name, category: tempItemTwo.category, id: tempItemTwo.id, selected: tempItemTwo.selected)
                    }
                    if tempItemTwo.category == 4 {
                        self.hair_models.append(bagModelStore(name: tempItemTwo.name, category: tempItemTwo.category, id: tempItemTwo.id, selected: tempItemTwo.selected))
                        self.worn_items[4] = bagModelStore(name: tempItemTwo.name, category: tempItemTwo.category, id: tempItemTwo.id, selected: tempItemTwo.selected)
                    }
                }
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            } catch let jsonErr {
                print(jsonErr)
            }
        }
        task.resume()
    }
}

struct bagModelArray: Codable {
    let results: [bagModelDecode]
}

struct bagModelDecode: Codable {
    let name: String
    let category: Int
    let id: Int
}

// struct to store data for each item in the shop
struct bagModelStore: Codable {
    let name: String
    let category: Int
    let id: Int
    let selected: Bool
    
    //ask about selected
    init(name: String, category: Int, id: Int, selected: Bool) {
        self.name = name
        self.category = category
        self.selected = selected
        self.id = id
    }
}
