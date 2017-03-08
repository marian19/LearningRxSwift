//
//  ViewController.swift
//  LearningRxSwift
//
//  Created by Marian on 3/5/17.
//  Copyright © 2017 Marian. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController{

    let shownCities: Variable<[String]> = Variable(["New York", "London", "Oslo", "Warsaw", "Berlin", "Praga"])

    let allCities = ["New York", "London", "Oslo", "Warsaw", "Berlin", "Praga"] // Our mocked API data source
    let disposeBag = DisposeBag() // Bag of disposables to release them when view is being deallocated
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchBar
            .rx.text // Observable property thanks to RxCocoa
            .orEmpty // Make it non-optional
            .debounce(0.5, scheduler: MainScheduler.instance) // Wait 0.5 for changes.
            .distinctUntilChanged() // If they didn't occur, check if the new value is the same as old.
            .filter { !$0.isEmpty } // If the new value is really new, filter for non-empty query.
            .subscribe(onNext: { [unowned self] query in // Here we subscribe to every new value, that is not empty (thanks to filter above).
                self.shownCities.value = self.allCities.filter { $0.hasPrefix(query) } // We now do our "API Request" to find cities.
                self.tableView.reloadData() // And reload table view data.
            })
            .addDisposableTo(disposeBag)

        shownCities.asObservable()
            .observeOn(MainScheduler.instance)
            .bindTo(tableView.rx.items(cellIdentifier: "Cell")) { (index, element, cell) in
                print(element)
                cell.textLabel?.text = element
            }
            .addDisposableTo(disposeBag)
    }
    


}

