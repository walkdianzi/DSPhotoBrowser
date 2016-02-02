//
//  WeixinOneViewController.m
//  DSPhotoBrowser
//
//  Created by dasheng on 16/1/18.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import "WeixinOneViewController.h"
#import "UIImageView+WebCache.h"
#import "DSPhotoModel.h"
#import "WXPhotoBrowserVC.h"

@interface WeixinOneViewController(){
    
    NSMutableArray   *_photoModels;
}

@end

@implementation WeixinOneViewController

- (void)dealloc{
    
   NSLog(@"我已经释放了");
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 2000);
    contentScrollView.scrollEnabled = YES;
    [self.view addSubview:contentScrollView];
    
    NSArray *imageArray = @[@"http://pic.meizitu.com/wp-content/uploads/2015a/11/11/01.jpg",
                            @"http://pic.meizitu.com/wp-content/uploads/2015a/11/11/02.jpg",
                            @"http://pic.meizitu.com/wp-content/uploads/2015a/11/11/03.jpg",
                            @"http://pic.meizitu.com/wp-content/uploads/2015a/11/11/04.jpg"];
    
    _photoModels = [[NSMutableArray alloc] initWithCapacity:[imageArray count]];
    
    for (int i = 0; i<[imageArray count]; i++) {
        
        int row = i/2;
        int cell = i%2;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + (100+5)*cell, (100+5)*row + 300, 100, 100)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:i]]placeholderImage:nil];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        imageView.clipsToBounds = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick:)];
        [imageView addGestureRecognizer:tapGesture];
        [contentScrollView addSubview:imageView];
        
        DSPhotoModel *photoModel = [[DSPhotoModel alloc] init];
        photoModel.image_HD_U = @"http://pic.meizitu.com/wp-content/uploads/2015a/11/11/05.jpg";
        photoModel.sourceImageView = imageView;
        photoModel.image = imageView.image;
        [_photoModels addObject:photoModel];
    }
}

- (void)imageViewClick:(UITapGestureRecognizer *)tapGesture{
    
    WXPhotoBrowserVC *VC = [[WXPhotoBrowserVC alloc] init];
    VC.handleVC = self;
    VC.type = DSPhotoBrowserTypeFadeIn;
    VC.currentImageIndex = tapGesture.view.tag;
    VC.photoModels = _photoModels;
    [VC show];
}

@end
