//
//  PushTypeViewController.m
//  DSPhotoBrowser
//
//  Created by dasheng on 16/1/14.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import "PushTypeViewController.h"
#import "UIImageView+WebCache.h"
#import "DSPhotoBrowserVC.h"
#import "DSPhotoModel.h"

@interface PushTypeViewController(){
    
    NSArray   *_photoModels;
}

@end


@implementation PushTypeViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:@"http://pic.meizitu.com/wp-content/uploads/2015a/11/11/02.jpg"]placeholderImage:nil];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick:)];
    [imageView addGestureRecognizer:tapGesture];
    [self.view addSubview:imageView];
    
    DSPhotoModel *photoModel = [[DSPhotoModel alloc] init];
    photoModel.image_HD_U = @"http://pic.meizitu.com/wp-content/uploads/2015a/11/11/02.jpg";
    photoModel.sourceImageView = imageView;
    _photoModels = @[photoModel];
}


-(void)imageViewClick:(id)sender{
    
    
    DSPhotoBrowserVC *VC = [[DSPhotoBrowserVC alloc] init];
    VC.handleVC = self;
    VC.type = DSPhotoBrowserTypePush;
    VC.isIndexLabel = NO;
    VC.currentImageIndex = 0;
    VC.photoModels = _photoModels;
    [VC show];
}

- (void)dealloc{
    
    NSLog(@"我已经释放了");
}

@end
