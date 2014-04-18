//
//  XmlTestCell.h
//  XmlTest
//
//  Created by ye liang on 13-9-3.
//  Copyright (c) 2013年 arvato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeViewNode.h"
@interface XmlTestCell : UITableViewCell
{

}
@property (retain, nonatomic) IBOutlet UIButton *cellButton;
@property (retain, nonatomic) IBOutlet UILabel *configLabel;
@property (retain, nonatomic) IBOutlet UILabel *refLabel;
@property (retain, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (retain, nonatomic) IBOutlet UILabel *qtnLabel;

@property (retain, nonatomic) IBOutlet UILabel *moduleLabel;
@property (retain, nonatomic) IBOutlet UILabel *typeLabel;
@property (retain, strong) TreeViewNode *treeNode;
- (void)setTheButtonBackgroundImage:(UIImage *)backgroundImage;
@end
