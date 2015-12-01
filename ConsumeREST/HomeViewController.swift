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
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let cellId = "homeCell"
    let model = HomeModel()
    let tableView = UITableView(frame: CGRectMake(0, 0, AppConstant.appWidth, AppConstant.appHeight))
    var feeds = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prefersStatusBarHidden()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        bindModel()
        
    }
    
    func bindModel(){
        model.refreshHome()
        model.feedsObserve.observe { (feeds) -> Void in
            self.feeds = feeds
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Data source and delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 10
        return feeds.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       //TODO: fix something stupid here
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath)
        let url = (self.feeds.objectAtIndex(indexPath.row) as! ImageObject).getUrl()
        let imageView = UIImageView(frame: CGRectMake(0, 10, cell.frame.width, cell.frame.height - 10))
        let image = UIImage(named: "image-sample2")
        imageView.image = image
        imageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "placeholder-image"))
        cell.backgroundView = UIView()
        cell.backgroundView!.addSubview(imageView)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return AppConstant.appWidth * 9 / 16
    }
    
}