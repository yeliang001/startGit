//
//  TreeViewNode.h
//  XmlTest
//
//  Created by ye liang on 13-9-4.
//  Copyright (c) 2013年 arvato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeViewNode : NSObject

@property (nonatomic) NSUInteger nodeLevel;
@property (nonatomic) BOOL isExpanded;
@property (nonatomic, strong) id nodeObject;
@property (nonatomic, strong) NSMutableArray *nodeChildren;
@end
