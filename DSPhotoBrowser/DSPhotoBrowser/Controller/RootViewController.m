//
//  RootViewController.m
//  DSCategories
//
//  Created by dasheng on 15/12/17.
//  Copyright © 2015年 dasheng. All rights reserved.
//

#import "RootViewController.h"
#import "DSProgressView.h"
@interface RootViewController(){
    
    NSDictionary *_itemsName;
}

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"图片浏览";
    _items = @{
               
               @"PhotoBrowserType":@[
                            @"PushType",
                            @"TransformType",
                            @"FadeInType",
                            @"WeixinOne",
                            @"OnlyImage",
                        ],
               @"微信":@[
                            @"WeixinTimeLine",
                            @"WeixinTwo",
                       ],
               @"么么嗖":@[
                            @"MMSOne"
                       ]
             };
    
    _itemsName = @{
                   
                   @"PhotoBrowserType":@[
                           @"PushType",
                           @"TransformType",
                           @"FadeInType",
                           @"FadeInType多图",
                           @"图片为UIImage，不为Url",
                            ],
                   
                   @"微信":@[
                             @"朋友圈列表里的浏览图片",
                             @"微信文章浏览图片",
                           ],
                   @"么么嗖":@[
                             @"么么嗖商品图片浏览"
                           ]
                   };
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableView reloadData];
        
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[_items allKeys] count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_items allKeys][section];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_items objectForKey:[_items allKeys][section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text =  [_itemsName objectForKey:[_itemsName allKeys][indexPath.section]][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *name =  [_items objectForKey:[_items allKeys][indexPath.section]][indexPath.row];
    NSString *className = [name stringByAppendingString:@"ViewController"];
    Class class = NSClassFromString(className);
    UIViewController *controller = [[class alloc] init];
    controller.title = name;
    [self.navigationController pushViewController:controller animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
