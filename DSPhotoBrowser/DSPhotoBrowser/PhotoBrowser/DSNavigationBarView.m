//
//  DSNavigationBarView.m
//  DSPhotoBrowser
//
//  Created by dasheng on 16/1/15.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import "DSNavigationBarView.h"
#import "DSPhotoBrowserConfig.m"

@implementation DSNavigationBarView

- (instancetype)init{
    
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kAPPWidth, 64);
        [self initObjects];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initObjects];
    }
    return self;
}


- (void)initObjects{
    
    UIImage *backImage=[UIImage imageNamed:@"fan_hui_an_niu"];
    _backbtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 20,50, 44)];
    [_backbtn setImage:backImage forState:UIControlStateNormal];
    _backbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_backbtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [_backbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [self addSubview:_backbtn];
    
    _line = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, kAPPWidth, 0.5)];
    _line.backgroundColor = UIColorFromRGB(0xdddddd);
    [self addSubview:_line];
    
    _navigationTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, kAPPWidth-100, 44)];
    _navigationTitleLbl.font = [UIFont systemFontOfSize:16];
    _navigationTitleLbl.textColor = UIColorFromRGB(0x333333);
    _navigationTitleLbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_navigationTitleLbl];
}

- (void)backClick:(UIButton *)sender{
    
    self.backBlock(sender);
}

@end
