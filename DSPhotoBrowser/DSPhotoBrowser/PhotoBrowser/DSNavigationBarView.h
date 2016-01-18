//
//  DSNavigationBarView.h
//  DSPhotoBrowser
//
//  Created by dasheng on 16/1/15.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSNavigationBarView : UIView

@property(nonatomic, strong)UILabel   *navigationTitleLbl;
@property(nonatomic, strong)UIButton  *backbtn;
@property(nonatomic, strong)UIView    *line;


@property (nonatomic, strong) void (^backBlock)(UIButton *btn);

@end
