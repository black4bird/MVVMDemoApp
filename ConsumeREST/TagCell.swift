//
//  TagCell.swift
//  ConsumeREST
//
//  Created by LNKN on 05/12/15.
//  Copyright © 2015 LNKN. All rights reserved.
//

import Foundation
import UIKit

class TagCell: UICollectionViewCell {
    let tagLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSubviews(){
        self.addSubview(tagLabel)
        tagLabel.frame = CGRectMake(0,0,self.frame.width,self.frame.height)
    }
}