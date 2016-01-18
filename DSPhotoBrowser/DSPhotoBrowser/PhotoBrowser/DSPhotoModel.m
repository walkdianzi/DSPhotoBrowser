//
//  DSPhotoModel.m
//  DSPhotoBrowser
//
//  Created by dasheng on 16/1/14.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import "DSPhotoModel.h"

@implementation DSPhotoModel


-(CGRect)sourceFrame{
    CGRect _frame = [_sourceImageView convertRect:_sourceImageView.bounds toView:_sourceImageView.window];
    return CGRectMake(_frame.origin.x, _frame.origin.y, _frame.size.width, _frame.size.height);
}

@end
