//
//  CreatePostInfoViewController.swift
//  ConsumeREST
//
//  Created by LNKN on 05/12/15.
//  Copyright © 2015 LNKN. All rights reserved.
//

import Foundation
import UIKit
import Bond
class CreatePostInfoViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource{
    
    let identifier = "tagCell"
    let model = CreatePostModel()
    var tagArray = NSArray()
    var selectedTag = NSMutableArray()
    var postImage = UIImage()
    let imageView = UIImageView()
    let descriptionTextView = UITextView()
    var tagCollectionView : UICollectionView
    let doneButton = UIButton()
    var image = UIImage()
    init(image: UIImage){
        self.image = image
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSizeMake(90, 60)
        flowLayout.scrollDirection = .Horizontal
        
        tagCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
        self.postImage = image
        super.init(nibName: nil, bundle: nil)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.translucent = false
    }
    override func viewDidLoad() {
        view.addSubview(imageView)
        view.addSubview(descriptionTextView)
        view.addSubview(tagCollectionView)
        view.addSubview(doneButton)
        var posY :CGFloat = 0;

        imageView.frame=CGRectMake(0, 0, AppConstant.appWidth, AppConstant.appWidth*3/4)
        imageView.image = postImage
        posY = imageView.frame.height
        
        descriptionTextView.frame = CGRectMake(0, posY, AppConstant.appWidth, 200)
        descriptionTextView.backgroundColor = UIColor.redColor()
        posY += descriptionTextView.frame.height
        
        tagCollectionView.frame = CGRectMake(0, posY, AppConstant.appWidth, 120)
        tagCollectionView.backgroundColor = UIColor.yellowColor()
        tagCollectionView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5)
        posY += tagCollectionView.frame.height
        
        doneButton.frame = CGRectMake(0,posY,AppConstant.appWidth,50)
        doneButton.backgroundColor = UIColor.greenColor()
        doneButton.setTitle("DONE", forState: .Normal)
        doneButton.contentHorizontalAlignment = .Center
        doneButton.contentVerticalAlignment = .Center
        doneButton.bnd_tap.observe {
            print(self.descriptionTextView.text!)
            WebService.sharedInstance.queryForCreateImage(self.image, description: self.descriptionTextView.text, tagArray: self.selectedTag)
        }
        
        
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: identifier)
        tagCollectionView.allowsMultipleSelection = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        imageView.addGestureRecognizer(tapGesture)
        imageView.userInteractionEnabled = true
        bindModel({})
    }
    
    func bindModel(completionHandler:()->Void){
        model.refreshTagArray()
        model.tagsObserve.observe { (feeds) -> Void in
            self.tagArray = feeds
            self.tagCollectionView.reloadData()
            completionHandler()
        }
    }

    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    //MARK: COllection view delegate and data source
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return tagArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
        let text = (tagArray.objectAtIndex(indexPath.row) as! TagObject).getName()
        let label = UILabel(frame: CGRectMake(0,0,cell.frame.width,cell.frame.height))
        label.textAlignment = .Center
        label.textColor = UIColor.redColor()
        label.text = text
        label.font = UIFont(name: "AmericanTypewriter-Bold", size: 12)
        label.backgroundColor = UIColor.clearColor()
        cell.backgroundView = UIView()
        cell.backgroundView?.addSubview(label)
        cell.backgroundColor = !cell.selected ? UIColor.orangeColor() : UIColor.purpleColor()
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = tagCollectionView.cellForItemAtIndexPath(indexPath)
        let text = (tagArray.objectAtIndex(indexPath.row) as! TagObject).getName()
        selectedTag.addObject(text)
        cell?.backgroundColor = UIColor.purpleColor()
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = tagCollectionView.cellForItemAtIndexPath(indexPath)
        let text = (tagArray.objectAtIndex(indexPath.row) as! TagObject).getName()
        selectedTag.removeObject(text)
        cell?.backgroundColor = UIColor.orangeColor()
    }
}