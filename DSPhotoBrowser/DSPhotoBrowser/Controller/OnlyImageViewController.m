//
//  OnlyImageViewController.m
//  DSPhotoBrowser
//
//  Created by dasheng on 16/5/28.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import "OnlyImageViewController.h"
#import "DSPhotoModel.h"
#import "DSPhotoBrowserVC.h"

@interface OnlyImageViewController(){
    
    NSArray   *_photoModels;
}

@end

@implementation OnlyImageViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [imageView setImage:[UIImage imageNamed:@"onlyImage"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick:)];
    [imageView addGestureRecognizer:tapGesture];
    [self.view addSubview:imageView];
    
    DSPhotoModel *photoModel = [[DSPhotoModel alloc] init];
    photoModel.image = [UIImage imageNamed:@"onlyImage"];
    photoModel.sourceImageView = imageView;
    _photoModels = @[photoModel];
}


-(void)imageViewClick:(id)sender{
    
    
    DSPhotoBrowserVC *VC = [[DSPhotoBrowserVC alloc] init];
    VC.handleVC = self;
    VC.type = DSPhotoBrowserTypeFadeIn;
    VC.currentImageIndex = 0;
    VC.photoModels = _photoModels;
    [VC show];
}
@end
