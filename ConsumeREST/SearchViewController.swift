//
//  SearchViewController.swift
//  ConsumeREST
//
//  Created by LNKN on 07/12/15.
//  Copyright © 2015 LNKN. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate{
    let model = SearchModel()
    let sampleArray1 = ["lala","lili","lolo"]
    let sampleArray2 = ["haha","hihi","hoho"]
    var currentArray :[String] = []
    var filterArray:[String] = []
    let searchBar = UISearchBar(frame: CGRectMake(0,0,AppConstant.appWidth,100))
    let tableView = UITableView(frame: CGRectMake(0, 100, AppConstant.appWidth, AppConstant.appHeight))
    var searchActive: Bool = false
    let searchController = UISearchController()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.translucent = false
    }
    override func viewDidLoad() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
//        searchController.searchResultsUpdater = self
//        searchController.searchBar.scopeButtonTitles = ["User","Tag","City"]
        searchBar.scopeButtonTitles = ["User","Tag","City"]
        searchBar.showsScopeBar = true
        searchBar.sizeToFit()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        bindModel("User",completionHandler: {})
    }
    

    func bindModel(type: String, completionHandler:()->Void){
        if(type=="User"){
            model.refreshAllUsername()
            model.usernameObserve.observe { (feeds) -> Void in
                self.currentArray = feeds
                self.tableView.reloadData()
                completionHandler()
            }
        } else if (type=="Tag"){
            model.refreshAllTag()
            model.tagsObserve.observe { (feeds) -> Void in
                self.currentArray = feeds
                self.tableView.reloadData()
                completionHandler()
            }
        } else if (type=="City"){
            model.refreshAllCity()
            model.cityObserve.observe { (feeds) -> Void in
                self.currentArray = feeds
                self.tableView.reloadData()
                completionHandler()
        }
        }
    }

    
    
    //search
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filterArray = currentArray.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        
        if(filterArray.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if(selectedScope==0){
            bindModel("User", completionHandler: {
                    self.tableView.reloadData()
            })
        }else if (selectedScope==1){
            bindModel("Tag", completionHandler: {
                    self.tableView.reloadData()
            })
        }else if (selectedScope==2){
            bindModel("City", completionHandler: {
                    self.tableView.reloadData()
            })
        }

    }
    
    //table view
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchActive){
            return filterArray.count
        }
        return currentArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        if(searchActive){
            cell.textLabel?.text = filterArray[indexPath.row]
        } else {
            cell.textLabel?.text = currentArray[indexPath.row];
        }
        
        return cell;
        
    }
    

    
    
}