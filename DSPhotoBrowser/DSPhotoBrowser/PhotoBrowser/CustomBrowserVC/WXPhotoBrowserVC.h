//
//  WXPhotoBrowserVC.h
//  DSPhotoBrowser
//
//  Created by dasheng on 16/1/18.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import "DSPhotoBrowserVC.h"


@protocol WXPhotoBrowserVC <NSObject>

- (void)dismissAtIndex:(NSInteger)index;

@end


@interface WXPhotoBrowserVC : UIViewController

/*-------必选------*/
@property(nonatomic, strong)UIViewController   *handleVC;
@property(nonatomic, strong)NSArray            *photoModels;        //图片数组
@property(nonatomic, assign)NSInteger          currentImageIndex;   //当前图片的位置数


/*------可选------*/
@property(nonatomic, assign)DSPhotoBrowserType type;                //显示的动画类型
@property(nonatomic, assign)BOOL               isNavigationBar;     //是否显示导航栏 (默认不显示)
@property(nonatomic, assign)BOOL               isIndexLabel;        //是否显示总张数label（默认显示）
@property(nonatomic, weak)id<DSPhotoBrowserVCDelegate>delegate;

- (void)show;
- (void)dismiss;

@end
