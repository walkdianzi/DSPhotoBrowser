//
//  FadeInTypeViewController.m
//  DSPhotoBrowser
//
//  Created by dasheng on 16/1/14.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import "FadeInTypeViewController.h"
#import "UIImageView+WebCache.h"
#import "DSPhotoBrowserVC.h"
#import "DSPhotoModel.h"

@interface FadeInTypeViewController(){
    
    NSArray   *_photoModels;
}

@end

@implementation FadeInTypeViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:@"http://pic.meizitu.com/wp-content/uploads/2015a/11/11/02.jpg"]placeholderImage:nil];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    
    DSPhotoModel *photoModel = [[DSPhotoModel alloc] init];
    photoModel.image_HD_U = @"http://pic.meizitu.com/wp-content/uploads/2015a/11/11/02.jpg";
    photoModel.sourceImageView = imageView;
    _photoModels = @[photoModel,photoModel];
    
    UIButton *ab = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 50, 50)];
    ab.backgroundColor = [UIColor redColor];
    [ab addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ab];
}


-(void)click:(UIButton *)sender{
    
    
    DSPhotoBrowserVC *VC = [[DSPhotoBrowserVC alloc] init];
    VC.handleVC = self;
    VC.type = DSPhotoBrowserTypeFadeIn;
    VC.currentImageIndex = 0;
    VC.photoModels = _photoModels;
    [VC show];
}

@end
