//
//  XmlTestViewController.h
//  XmlTest
//
//  Created by ye liang on 13-9-2.
//  Copyright (c) 2013年 arvato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataXMLNode.h"
@interface XmlTestViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *titleArr;
    NSMutableArray *elementArr;
    GDataXMLElement *currentElement;
    NSMutableArray *curElementArr;
    int level;
}
@property (retain, nonatomic)  NSMutableArray *nodes;
@property (retain, nonatomic)  NSMutableArray *LeafNodeArr;
@property (nonatomic, retain)  NSMutableArray *displayArray;
@property (nonatomic, retain)  NSMutableArray *rootNodes;
@property (retain, nonatomic) IBOutlet UITableView *dataTable;
@end
