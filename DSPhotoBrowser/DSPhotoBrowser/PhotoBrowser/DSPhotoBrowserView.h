//
//  DSPhotoBrowserView.h
//  DSPhotoBrowser
//
//  Created by dasheng on 16/1/14.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSPhotoBrowserConfig.m"
@interface DSPhotoBrowserView : UIView

@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) UIImageView *imageview;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) DSPhotoBrowserType type;
@property (nonatomic, assign) BOOL beginLoadingImage;
@property (nonatomic, assign) BOOL hasLoadedImage;    //图片加载成功

//单击回调
@property (nonatomic, strong) void (^singleTapBlock)(UITapGestureRecognizer *recognizer);

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder withOrginImage:(UIImageView *)orginImageView;

@end
