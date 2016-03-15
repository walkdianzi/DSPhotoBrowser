//
//  MMSPhotoBrowserVC.h
//  DSPhotoBrowser
//
//  Created by dasheng on 16/3/15.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMSPhotoBrowserVC : UIViewController

/*-------必选------*/
@property(nonatomic, strong)UIViewController   *handleVC;
@property(nonatomic, strong)NSArray            *photoModels;        //图片数组


- (void)show;
- (void)dismiss;

@end
