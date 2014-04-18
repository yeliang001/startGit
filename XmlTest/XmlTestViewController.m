//
//  XmlTestViewController.m
//  XmlTest
//
//  Created by ye liang on 13-9-2.
//  Copyright (c) 2013年 arvato. All rights reserved.
//

#import "XmlTestViewController.h"
#import "GDataXMLNode.h"
#import "XmlTestCell.h"
#import "TreeViewNode.h"
@interface XmlTestViewController ()

@end

@implementation XmlTestViewController
@synthesize nodes,LeafNodeArr,displayArray,rootNodes;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self praseXmlAct];
    [self initArrayDic];
    [self initTree];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initArrayDic{
    self.nodes = [[[NSMutableArray alloc] initWithCapacity:100] autorelease];
    self.LeafNodeArr = [[[NSMutableArray alloc] init] autorelease];
    self.displayArray = [[[NSMutableArray alloc] init] autorelease];
    self.rootNodes = [[[NSMutableArray alloc] init] autorelease];
    level = -1;
}

- (void)defineArr{
    titleArr = [[NSArray alloc] initWithObjects:@"Config",@"Ref",@"Description",@"Qtn",@"Module",@"Type", nil];
}

- (void)initTree{
    //获取工程目录的xml文件
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Template" ofType:@"xml"];
    NSData *xmlData = [[NSData alloc] initWithContentsOfFile:filePath];
    
    //使用NSData对象初始化
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData  options:0 error:nil];
    
    //获取根节点（Users）
    GDataXMLElement *rootElement = [doc rootElement];
    elementArr = (NSMutableArray*)[rootElement nodesForXPath:@"TreeData/Data" error:nil];
    currentElement = [elementArr objectAtIndex:0];
    [self noChildrenNodes:currentElement];
    for (int i=0; i<self.nodes.count; i++) {
//        NSLog(@"%@",[[((TreeViewNode*)[self.nodes objectAtIndex:i]).nodeObject attributeForName:@"Config"] stringValue]);
//        NSLog(@"...%d",((TreeViewNode*)[self.nodes objectAtIndex:i]).nodeLevel);
        [self setNodess:[self.nodes objectAtIndex:i]];
    }
    [self fillDisplayArray];
    [self.dataTable reloadData];
}

-(void)setNodeArr:(TreeViewNode*)tvn{
    [self.nodes addObject:tvn];
}

-(void)setNodess:(TreeViewNode*)tvn{
    if (tvn.nodeLevel == 0) {
        [rootNodes addObject:tvn];
    }else{
        TreeViewNode *tvnTemp = [rootNodes lastObject];
        if (tvnTemp.nodeChildren == nil) {
            tvnTemp.isExpanded = NO;
            NSMutableArray *nma = [[NSMutableArray alloc] initWithCapacity:5];
            tvnTemp.nodeChildren = nma;
            [nma release];
            [tvnTemp.nodeChildren addObject:tvn];
        }else if((tvnTemp.nodeLevel+1) == tvn.nodeLevel){
            [tvnTemp.nodeChildren addObject:tvn];
        }else{
            for (; ; ) {
                tvnTemp =[tvnTemp.nodeChildren lastObject];
                if (tvnTemp.nodeChildren == nil || ((tvnTemp.nodeLevel+1) == tvn.nodeLevel)) {
                    break;
                }
            }
            if (tvnTemp.nodeChildren == nil) {
                tvnTemp.isExpanded = NO;
                NSMutableArray *nma = [[NSMutableArray alloc] initWithCapacity:5];
                tvnTemp.nodeChildren = nma;
                [nma release];
                [tvnTemp.nodeChildren addObject:tvn];
            }else if((tvnTemp.nodeLevel+1) == tvn.nodeLevel){
                [tvnTemp.nodeChildren addObject:tvn];
            }
        }
    }
}

- (void)noChildrenNodes:(GDataXMLElement*)element{
    NSArray *tempArr = [element nodesForXPath:@"Item" error:nil];
    if (tempArr.count<=0) {
//        TreeViewNode *node = [[TreeViewNode alloc] init];
//        node.nodeObject = element;
        [self.LeafNodeArr addObject:element];
        level--;
//        [self setNodeArr:node];
//        return;
    }
    else{
        
        int tempLevel = level+1;
        
        for (int i=0; i<tempArr.count; i++) {
            TreeViewNode *node = [[TreeViewNode alloc] init];
            node.nodeObject = [tempArr objectAtIndex:i];
            node.nodeLevel = tempLevel;
            level++;
            [self setNodeArr:node];
            [self noChildrenNodes:[tempArr objectAtIndex:i]];
        }
        level--;
    }
}

- (void)praseXmlAct{
    //获取工程目录的xml文件
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Template" ofType:@"xml"];
    NSData *xmlData = [[NSData alloc] initWithContentsOfFile:filePath];
    
    //使用NSData对象初始化
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData  options:0 error:nil];
    
    //获取根节点（Users）
    GDataXMLElement *rootElement = [doc rootElement];
//    NSArray *users = [rootElement children];
    
    //获取根节点下的节点（User）nodesForXPath
    elementArr = (NSMutableArray*)[rootElement nodesForXPath:@"TreeData/Data" error:nil];
//    NSArray *users = [rootElement elementsForName:@"TreeData"];
    currentElement = [elementArr objectAtIndex:0];
    NSLog(@"Nameeeee id is:%@",[[currentElement attributeForName:@"Name"] stringValue]); 
    for (GDataXMLElement *element in elementArr) {
        //User节点的id属性
        NSString *Name = [[element attributeForName:@"Name"] stringValue];
        NSLog(@"Name id is:%@",Name);
    }
}

- (void)expandCollapseNode:(NSNotification *)notification
{
    [self fillDisplayArray];
    [self.dataTable reloadData];
}


- (void)fillDisplayArray
{
    //    NSLog(@"nodes = %@",nodes);
    NSMutableArray *a = [[NSMutableArray alloc]init];
    self.displayArray = a;
    [a release];
    for (TreeViewNode *node in rootNodes) {
        [self.displayArray addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
    //    NSLog(@"display = %@",self.displayArray);
}

//This function is used to add the children of the expanded node to the display array
- (void)fillNodeWithChildrenArray:(NSArray *)childrenArray
{
    for (TreeViewNode *node in childrenArray) {
        [self.displayArray addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
    //    NSLog(@"display = %@",self.displayArray);
}

#pragma mark -
#pragma mark Table view data source

-(NSInteger)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 22;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 35;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSArray *tempArray = [currentElement nodesForXPath:@"Item" error:nil];
//    curElementArr = [[NSMutableArray alloc] initWithArray:tempArray];
////    [tempArray release];
//    return curElementArr.count;
    return self.displayArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //It's cruical here that this identifier is treeNodeCell and that the cell identifier in the story board is anything else but not treeNodeCell
    NSLog(@"count = %d",curElementArr.count);
    static NSString *CellIdentifier = @"treeNodeCell";
    UINib *nib = [UINib nibWithNibName:@"ProjectCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    
    XmlTestCell *cell = (XmlTestCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    TreeViewNode *node = [self.displayArray objectAtIndex:indexPath.row];
    cell.treeNode = node;
    //获取根节点下的节点（User）nodesForXPath
//    NSArray *tempElementArr = [currentElement nodesForXPath:@"Item" error:nil];
    int tempRow = indexPath.row;
    NSString *tempConfig      = [[((TreeViewNode*)[self.displayArray objectAtIndex:tempRow]).nodeObject attributeForName:@"Config"] stringValue];
    NSString *tempRef         = [[((TreeViewNode*)[self.displayArray objectAtIndex:tempRow]).nodeObject attributeForName:@"Ref"] stringValue];
    NSString *tempDescription = [[((TreeViewNode*)[self.displayArray objectAtIndex:tempRow]).nodeObject attributeForName:@"Description"] stringValue];
    NSString *tempQtn         = [[((TreeViewNode*)[self.displayArray objectAtIndex:tempRow]).nodeObject attributeForName:@"Qtn"] stringValue];
    NSString *tempModule      = [[((TreeViewNode*)[self.displayArray objectAtIndex:tempRow]).nodeObject attributeForName:@"Module"] stringValue];
    NSString *tempType        = [[((TreeViewNode*)[self.displayArray objectAtIndex:tempRow]).nodeObject attributeForName:@"Type"] stringValue];
    cell.configLabel.text = tempConfig;
    cell.refLabel.text = tempRef;
    cell.descriptionLabel.text = tempDescription;
    cell.qtnLabel.text = tempQtn;
    cell.moduleLabel.text = tempModule;
    cell.typeLabel.text = tempType;
    
    if (![LeafNodeArr containsObject:node.nodeObject]) {
        cell.cellButton.hidden = NO;
    }
    if (node.isExpanded) {
        [cell setTheButtonBackgroundImage:[UIImage imageNamed:@"Open.png"]];
    }
    else {
        [cell setTheButtonBackgroundImage:[UIImage imageNamed:@"Close.png"]];
    }
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    [cell setNeedsDisplay];
    // Configure the c ell...
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    int row = [indexPath row];
    TreeViewNode *node = [self.displayArray objectAtIndex:indexPath.row];
    
    if (![LeafNodeArr containsObject:node.nodeObject]) {
        XmlTestCell *cell = (XmlTestCell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.treeNode.isExpanded = !cell.treeNode.isExpanded;
        [cell setSelected:NO];
        [self expandCollapseNode:nil];
    }
}

- (void)dealloc {
    self.nodes=nil;
    self.LeafNodeArr=nil;
    self.displayArray = nil;
    self.rootNodes = nil;
    [_dataTable release];
    [super dealloc];
}
@end
