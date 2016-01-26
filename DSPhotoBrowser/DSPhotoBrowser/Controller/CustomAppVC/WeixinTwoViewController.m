//
//  WeixinTwoViewController.m
//  DSPhotoBrowser
//
//  Created by dasheng on 16/1/26.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import "WeixinTwoViewController.h"
#import "UIImageView+WebCache.h"
#import "DSPhotoModel.h"
#import "DSPhotoBrowserVC.h"

@interface WeixinTwoViewController(){
    
    NSMutableArray   *_photoModels;
}

@end

@implementation WeixinTwoViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    
    
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 2000);
    contentScrollView.scrollEnabled = YES;
    [self.view addSubview:contentScrollView];
    
    NSArray *imageArray = @[@"http://pic.meizitu.com/wp-content/uploads/2015a/11/11/05.jpg",
                            @"http://pic.meizitu.com/wp-content/uploads/2015a/11/11/06.jpg",
                            @"http://pic.meizitu.com/wp-content/uploads/2015a/11/11/07.jpg",
                            @"http://pic.meizitu.com/wp-content/uploads/2015a/11/11/08.jpg"];
    
    _photoModels = [[NSMutableArray alloc] initWithCapacity:[imageArray count]];
    
    for (int i = 0; i<[imageArray count]; i++) {

        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100 + i*210, kAPPWidth - 20, 200)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:i]]placeholderImage:nil];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        imageView.clipsToBounds = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick:)];
        [imageView addGestureRecognizer:tapGesture];
        [contentScrollView addSubview:imageView];
        
        DSPhotoModel *photoModel = [[DSPhotoModel alloc] init];
        photoModel.image_HD_U = [imageArray objectAtIndex:i];
        photoModel.sourceImageView = imageView;
        [_photoModels addObject:photoModel];
    }
}

- (void)imageViewClick:(UITapGestureRecognizer *)tapGesture{
    
    DSPhotoBrowserVC *VC = [[DSPhotoBrowserVC alloc] init];
    VC.handleVC = self;
    VC.type = DSPhotoBrowserTypePush;
    VC.isIndexLabel = NO;
    VC.currentImageIndex = tapGesture.view.tag;
    VC.photoModels = _photoModels;
    [VC show];
}


@end
