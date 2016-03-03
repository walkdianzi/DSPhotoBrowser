//
//  DSProgressView.h
//  DSPhotoBrowser
//
//  Created by 橙子 on 16/3/1.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSProgressView : UIView

/**
 * lineWidth of the stroke
 */
@property (nonatomic) CGFloat lineWidth;

- (void)startAnimation;
- (void)stopAnimation;

@end
