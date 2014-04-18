//
//  XmlTestCell.m
//  XmlTest
//
//  Created by ye liang on 13-9-3.
//  Copyright (c) 2013年 arvato. All rights reserved.
//

#import "XmlTestCell.h"

@implementation XmlTestCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
//    CGRect cellFrame = self.cellLabel.frame;
    CGRect buttonFrame = self.configLabel.frame;
    int indentation = self.treeNode.nodeLevel * 15;
//    cellFrame.origin.x = buttonFrame.size.width + indentation + 5;
    buttonFrame.origin.x = 2 + indentation;
//    self.cellLabel.frame = cellFrame;
    self.configLabel.frame = buttonFrame;
//    [self.cellLabel setAdjustsFontSizeToFitWidth:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(expand:) name:@"ProjectTreeNodeClicked" object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTheButtonBackgroundImage:(UIImage *)backgroundImage
{
    [self.cellButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
}

- (void)dealloc {
    [_configLabel release];
    [_refLabel release];
    [_descriptionLabel release];
    [_moduleLabel release];
    [_qtnLabel release];
    [_typeLabel release];
    [_cellButton release];
    [super dealloc];
}
@end
