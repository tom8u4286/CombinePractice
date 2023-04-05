//
//  ViewController.swift
//  iOSAcademy.CombineBasic
//
//  Created by 曲奕帆 on 2023/4/5.
//

import UIKit
import Combine

class MyCustomTableCell: UITableViewCell {
    
}


class ViewController: UIViewController, UITableViewDataSource {

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(MyCustomTableCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var models = [String]()
    
    var observer: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        observer = APICaller.shared.fetchCompanies()
            // receive:讓Publisher丟出來的事件，丟到某一個執行緒中
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("Finished")
            case .failure(let error):
                print("error")
            }
        }, receiveValue: { [weak self] value in
            self?.models = value
            /// 由於先前已經使用receive，將資料丟給main執行緒，
            /// 這裡不需要再將reload的工作，用dispatchQueue丟給主執行緒。
            self?.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MyCustomTableCell else {
            fatalError()
        }
        cell.textLabel?.text = models[indexPath.row]
        return cell
    }


}

