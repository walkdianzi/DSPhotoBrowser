//
//  MMSOneViewController.m
//  DSPhotoBrowser
//
//  Created by dasheng on 16/3/15.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import "MMSOneViewController.h"
#import "UIImageView+WebCache.h"
#import "DSPhotoModel.h"
#import "MMSPhotoBrowserVC.h"

@interface MMSOneViewController (){
    
    NSMutableArray   *_photoModels;
}

@end

@implementation MMSOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 2000);
    contentScrollView.scrollEnabled = YES;
    [self.view addSubview:contentScrollView];
    
    NSArray *imageArray = @[@"http://7xj2go.com2.z0.glb.qiniucdn.com/small_01.jpg",
                            @"http://7xj2go.com2.z0.glb.qiniucdn.com/small_02.jpg",
                            @"http://7xj2go.com2.z0.glb.qiniucdn.com/small_03.jpg",
                            @"http://7xj2go.com2.z0.glb.qiniucdn.com/small_04.jpg"];
    NSArray *highDefinationImages = @[@"http://7xj2go.com2.z0.glb.qiniucdn.com/big_01.jpg",
                                      @"http://7xj2go.com2.z0.glb.qiniucdn.com/big_02.jpg",
                                      @"http://7xj2go.com2.z0.glb.qiniucdn.com/big_03.jpg",
                                      @"http://7xj2go.com2.z0.glb.qiniucdn.com/big_04.jpg"];
    
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
        photoModel.image_HD_U = [highDefinationImages objectAtIndex:i];
        photoModel.sourceImageView = imageView;
        photoModel.image = imageView.image;
        [_photoModels addObject:photoModel];
    }
}

- (void)imageViewClick:(UITapGestureRecognizer *)tapGesture{
    
    MMSPhotoBrowserVC *VC = [[MMSPhotoBrowserVC alloc] init];
    VC.handleVC = self;
    VC.photoModels = _photoModels;
    [VC show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
