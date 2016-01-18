//
//  WXPhotoBrowserVC.m
//  DSPhotoBrowser
//
//  Created by dasheng on 16/1/18.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import "WXPhotoBrowserVC.h"
#import "StyledPageControl.h"


@interface WXPhotoBrowserVC(){
    
    StyledPageControl    *_pageControl;
}

@end

@implementation WXPhotoBrowserVC


- (void)initIndexLabel{
    
    if (self.isIndexLabel) {
        _pageControl = [[StyledPageControl alloc] initWithFrame:CGRectMake(0, KAppHeight - 24, kAPPWidth, 10)];
        [_pageControl setDiameter:10];
        [_pageControl setGapWidth:10];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.userInteractionEnabled = NO;
        [_pageControl setCoreNormalColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]];
        [_pageControl setStrokeNormalColor:[UIColor clearColor]];
        [_pageControl setCoreSelectedColor:[UIColor whiteColor]];
        [_pageControl setStrokeSelectedColor:[UIColor whiteColor]];
        [_pageControl setPageControlStyle:PageControlStyleDefault];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.numberOfPages = (int)[self.photoModels count];
        _pageControl.currentPage = (int)self.currentImageIndex;
        [self.view addSubview:_pageControl];
    }
}

- (void)showIndexLabel{
    
    _pageControl.hidden = NO;
}

- (void)hideIndexLabel{
    
    _pageControl.hidden = YES;
}

- (void)setIndexLabelNumber:(NSInteger)index{
    
    _pageControl.currentPage = (int)index;
}
@end
