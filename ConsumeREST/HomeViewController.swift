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
class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    let cellId = "homeCell"
    let model = HomeModel()
    let refreshControl = UIRefreshControl()
    //let tableView = UITableView(frame: CGRectMake(0, 0, AppConstant.appWidth, AppConstant.appHeight))
    var feeds = NSArray()
    var collectionView : UICollectionView
    let cellSize = CGSizeMake(AppConstant.appWidth/3-1,AppConstant.appWidth/3)
    
    init(){
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = cellSize
        flowLayout.scrollDirection = .Vertical
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0)
        
        collectionView = UICollectionView(frame: CGRectMake(0, 0, AppConstant.appWidth, AppConstant.appHeight-64), collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        super.init(nibName: nil, bundle: nil)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prefersStatusBarHidden()

        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.alwaysBounceVertical = true

        refreshControl.addTarget(self, action: "refreshHome", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.addSubview(refreshControl)
        
    }
    
    func refreshHome(){
        refreshControl.beginRefreshing()
        bindModel { () -> Void in
            self.refreshControl.endRefreshing()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.redColor(), NSFontAttributeName:UIFont.appRegularFont(24)]
        self.navigationItem.title = "HOME"
        //bindModel()
        let backImageView = UIImageView(frame: CGRectMake(0,0,25,25))
        backImageView.image = UIImage(named: "back-icon")
        backImageView.contentMode = .ScaleAspectFit
        backImageView.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: "popToRootView")
        backImageView.addGestureRecognizer(tapGesture)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backImageView)
        bindModel({})
    }
    
    func popToRootView(){
//        self.navigationController?.popToRootViewControllerAnimated(true)
        self.navigationController?.popToViewController(self.navigationController!.viewControllers[1], animated: true)
    }

        
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

      //  self.tableView.reloadData()
        
    }
    
    func bindModel(completionHandler:()->Void){
        model.refreshHome()
        model.feedsObserve.observe { (feeds) -> Void in
            self.feeds = feeds.reverse()
            self.collectionView.reloadData()
            completionHandler()
        }
    }
    
    //MARK: - Data source and delegate
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath)
        let url = (self.feeds.objectAtIndex(indexPath.row) as! ImageObject).getUrl()
        
        let imageView = UIImageView(frame: CGRectMake(0, 10, cell.frame.width, cell.frame.height - 10))
        imageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "placeholder-image"))
        cell.backgroundView = UIView()
        cell.backgroundView!.addSubview(imageView)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let entity = self.feeds.objectAtIndex(indexPath.row) as! ImageObject
        let postVc = PostViewController(imageEntity: entity)
        self.navigationController!.pushViewController(postVc, animated: true)
    }

    
}