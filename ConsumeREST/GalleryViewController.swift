//
//  TagGalleryViewController.swift
//  ConsumeREST
//
//  Created by LNKN on 08/12/15.
//  Copyright © 2015 LNKN. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class TagGalleryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    let cellId = "tagCell"
    let model : TagGalleryModel?
    var tagname : String?
    var feeds = NSArray()
    let cellSize = CGSizeMake(AppConstant.appWidth/3-1,AppConstant.appWidth/3)
    var collectionView : UICollectionView
    
    init(tag: String){
        tagname = tag
        model = TagGalleryModel(name: tagname!)
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
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.redColor(), NSFontAttributeName:UIFont.appRegularFontBold(24)]
        self.navigationItem.title = "#"+tagname!
        //setup back button
        let backImageView = UIImageView(frame: CGRectMake(0,0,25,25))
        backImageView.image = UIImage(named: "back-icon")
        backImageView.contentMode = .ScaleAspectFit
        backImageView.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissView")
        backImageView.addGestureRecognizer(tapGesture)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backImageView)

    }
    
    func dismissView(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        bindModel({})
        
    }
    
    func bindModel(completionHandler:()->Void){
        model!.refreshImageArray()
        model!.imagesObserve.observe { (feeds) -> Void in
            self.feeds = feeds
            self.collectionView.reloadData()
            completionHandler()
        }
    }
    
    //MARK: Delegate and data source
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
}

class CityGalleryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    let cellId = "cityCell"
    let model : CityGalleryModel?
    var cityName : String?
    var feeds = NSArray()
    let cellSize = CGSizeMake(AppConstant.appWidth/3-1,AppConstant.appWidth/3)
    var collectionView : UICollectionView
    
    init(tag: String){
        cityName = tag
        model = CityGalleryModel(name: cityName!)
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
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.redColor(), NSFontAttributeName:UIFont.appRegularFontBold(24)]
        self.navigationItem.title = cityName!
        //setup back button
        let backImageView = UIImageView(frame: CGRectMake(0,0,25,25))
        backImageView.image = UIImage(named: "back-icon")
        backImageView.contentMode = .ScaleAspectFit
        backImageView.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissView")
        backImageView.addGestureRecognizer(tapGesture)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backImageView)
        
    }
    
    func dismissView(){
        self.navigationController?.popViewControllerAnimated(true)
    }

    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        bindModel({})
        
    }
    
    func bindModel(completionHandler:()->Void){
        model!.refreshImageArray()
        model!.imagesObserve.observe { (feeds) -> Void in
            self.feeds = feeds
            self.collectionView.reloadData()
            completionHandler()
        }
    }
    
    //MARK: Delegate and data source
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
}

class UsernameGalleryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    let cellId = "usernameCell"
    let model : UsernameGalleryModel?
    var userName : String?
    var feeds = NSArray()
    let cellSize = CGSizeMake(AppConstant.appWidth/3-1,AppConstant.appWidth/3)
    var collectionView : UICollectionView
    
    init(tag: String){
        userName = tag
        model = UsernameGalleryModel(name: userName!)
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
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.redColor(), NSFontAttributeName:UIFont.appRegularFontBold(24)]
        self.navigationItem.title = userName!
        //setup back button
        let backImageView = UIImageView(frame: CGRectMake(0,0,25,25))
        backImageView.image = UIImage(named: "back-icon")
        backImageView.contentMode = .ScaleAspectFit
        backImageView.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissView")
        backImageView.addGestureRecognizer(tapGesture)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backImageView)
        
    }
    
    func dismissView(){
        self.navigationController?.popViewControllerAnimated(true)
    }

    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        bindModel({})
        
    }
    
    func bindModel(completionHandler:()->Void){
        model!.refreshImageArray()
        model!.imagesObserve.observe { (feeds) -> Void in
            self.feeds = feeds
            self.collectionView.reloadData()
            completionHandler()
        }
    }
    
    //MARK: Delegate and data source
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
}