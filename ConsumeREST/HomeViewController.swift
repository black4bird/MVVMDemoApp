//
//  HomeViewController.swift
//  ConsumeREST
//
//  Created by LNKN on 27/11/15.
//  Copyright © 2015 LNKN. All rights reserved.
//

import Foundation
import UIKit
import Bond
import SDWebImage
class HomeViewController: UITableViewController {
    let cellId = "homeCell"
    let model = HomeModel()

    //let tableView = UITableView(frame: CGRectMake(0, 0, AppConstant.appWidth, AppConstant.appHeight))
    var feeds = NSArray()
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prefersStatusBarHidden()
        //tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellId)
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refresh
        
        bindModel({})
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //bindModel()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

      //  self.tableView.reloadData()
        
    }
    
    func refresh(){
        bindModel { () -> Void in
            self.refreshControl?.endRefreshing()
        }

    }
    func bindModel(completionHandler:()->Void){
        model.refreshHome()
        model.feedsObserve.observe { (feeds) -> Void in
            self.feeds = feeds.reverse()
            self.tableView.reloadData()
            completionHandler()
        }
    }
    
    //MARK: - Data source and delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath)
        let url = (self.feeds.objectAtIndex(indexPath.row) as! ImageObject).getUrl()
        let imageView = UIImageView(frame: CGRectMake(0, 10, cell.frame.width, cell.frame.height - 10))
        imageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "placeholder-image"))
        cell.backgroundView = UIView()
        cell.backgroundView!.addSubview(imageView)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return AppConstant.appWidth * 9 / 16
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let entity = (self.feeds.objectAtIndex(indexPath.row) as! ImageObject);

        let accVc = AcceleratorViewController(entity: entity)
        self.navigationController?.pushViewController(accVc, animated: true)
    }
    
}