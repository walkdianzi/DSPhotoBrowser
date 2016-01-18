//
//  DSPhotoBrowserConfig.m
//  DSPhotoBrowser
//
//  Created by dasheng on 16/1/14.
//  Copyright © 2016年 dasheng. All rights reserved.
//

typedef enum{
    
    DSPhotoBrowserTypePush,
    DSPhotoBrowserTypeTransform,   //从当前位置放大
    DSPhotoBrowserTypeFadeIn,      //渐现
    
}DSPhotoBrowserType;

typedef enum {
    DSWaitingViewModeLoopDiagram, // 环形
    DSWaitingViewModePieDiagram   // 饼型
} DSWaitingViewMode;


//颜色部分
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define kToastTime    2        //提示toast时间

#define kMinZoomScale 0.6f
#define kMaxZoomScale 2.0f

#define kAPPWidth [UIScreen mainScreen].bounds.size.width
#define KAppHeight [UIScreen mainScreen].bounds.size.height

#define kIsFullWidthForLandScape YES //是否在横屏的时候直接满宽度，而不是满高度，一般是在有长图需求的时候设置为YES

// browser中图片间的margin
#define DSPhotoBrowserImageViewMargin 10

// browser中显示图片动画时长
#define DSPhotoBrowserShowImageAnimationDuration 0.35f

// 图片下载进度指示进度显示样式（HZWaitingViewModeLoopDiagram 环形，HZWaitingViewModePieDiagram 饼型）
#define DSWaitingViewProgressMode HZWaitingViewModeLoopDiagram

// 图片下载进度指示器背景色
#define DSWaitingViewBackgroundColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]

// 图片下载进度指示器内部控件间的间距
#define DSWaitingViewItemMargin 10