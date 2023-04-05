//
//  ViewController.swift
//  iOSAcademy.CombineBasic
//
//  Created by 曲奕帆 on 2023/4/5.
//

import UIKit
import Combine

class MyCustomTableCell: UITableViewCell {
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("button", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemPink
        return button
    }()
    
    /// 在Cell這邊實作一個PassthroughSubject的Publisher。
    /// <String, Never>表示我們publish的資料型別為String，並且不會有錯誤發生。
    ///
    /// -Authors: Tomtom Chu
    /// -Date: 2023.4.5
    let action = PassthroughSubject<String, Never>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(button)
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped(){
        action.send("Button was tapped!")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = CGRect(x: 10, y: 3, width: contentView.frame.size.width - 20, height: contentView.frame.size.height - 6)
    }
}


class ViewController: UIViewController, UITableViewDataSource {

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(MyCustomTableCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var models = [String]()
    
    /// 由於有可能會有非常多個Cell，
    /// 每一個Cell都會有一組Publisher與Observer，
    /// 所以這裡常常會使用Array來存放這些Observers。
    ///
    /// -Authors: Tomtom Chu
    /// -Date: 2023.4.5
    /// var observer: AnyCancellable?
    var observers: [AnyCancellable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        APICaller.shared.fetchCompanies()
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
        // 利用.store將這個observer存入ovservers陣列中
        }).store(in: &observers)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MyCustomTableCell else {
            fatalError()
        }
        
        /// sink會回傳的是一個observer (subscriber)，
        /// 因此我們可以將這個物件(obserser)用變數存起來，方便管理。
        ///
        /// -Authors: Tomtom Chu
        /// -Date: 2023.4.5
        cell.action.sink { string in
            print(string)
        // 利用.store將這個observer存入ovservers陣列中
        }.store(in: &observers)
        
        return cell
    }


}

