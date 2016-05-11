//
//  MMSPhotoBrowserVC.m
//  DSPhotoBrowser
//
//  Created by dasheng on 16/3/15.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import "MMSPhotoBrowserVC.h"
#import "UIImageView+WebCache.h"
#import "DSPhotoModel.h"


#define kImageBaseTag 6666
#define kMaxZoomScale 2.0f

@interface MMSPhotoBrowserVC ()<UIScrollViewDelegate>{
    
    
}

@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) UIView       *contentView;
@property (nonatomic,strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic,strong) UITapGestureRecognizer *singleTap;

@end

@implementation MMSPhotoBrowserVC

- (instancetype)init{
    
    self = [super init];
    if (self) {
    
        [self.view addSubview:self.scrollview];
        [self.scrollview addSubview:self.contentView];
        [self.view addGestureRecognizer:self.doubleTap];
        [self.view addGestureRecognizer:self.singleTap];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIScrollView *)scrollview
{
    if (!_scrollview) {
        _scrollview = [[UIScrollView alloc] init];
        _scrollview.frame = [UIScreen mainScreen].bounds;
        _scrollview.backgroundColor = [UIColor blackColor];
        _scrollview.delegate = self;
        _scrollview.clipsToBounds = YES;
        _scrollview.minimumZoomScale = 1;
        _scrollview.maximumZoomScale = kMaxZoomScale;
        _scrollview.showsVerticalScrollIndicator = NO;
        _scrollview.showsHorizontalScrollIndicator = NO;
        self.scrollview.zoomScale = 1.0f;
    }
    return _scrollview;
}

- (UIView *)contentView{
    
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.frame = _scrollview.frame;
    }
    return _contentView;
}

- (UITapGestureRecognizer *)doubleTap
{
    if (!_doubleTap) {
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTap.numberOfTapsRequired = 2;
        _doubleTap.numberOfTouchesRequired  =1;
    }
    return _doubleTap;
}

- (UITapGestureRecognizer *)singleTap
{
    if (!_singleTap) {
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        _singleTap.numberOfTapsRequired = 1;
        _singleTap.numberOfTouchesRequired = 1;
        _singleTap.delaysTouchesBegan = YES;
        //只能有一个手势存在
        [_singleTap requireGestureRecognizerToFail:self.doubleTap];
        
    }
    return _singleTap;
}


#pragma mark - Click Methon

#pragma mark 双击
- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer{
    
    CGPoint touchPoint = [recognizer locationInView:self.view];
    if (self.scrollview.zoomScale <= 1.0) {
        
        CGFloat scaleX = touchPoint.x + self.scrollview.contentOffset.x;//需要放大的图片的X点
        CGFloat sacleY = touchPoint.y + self.scrollview.contentOffset.y;//需要放大的图片的Y点
        [self.scrollview zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
        
    } else {
        
        [self.scrollview setZoomScale:1.0 animated:YES]; //还原
    }
}

#pragma mark 单击
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer{
    
    [self dismiss];
}


#pragma mark - Other Methon

- (void)show{
    
    if (!_handleVC) {
        return;
    }
    
    //当前view的大小为屏幕的大小
    self.view.frame = [UIScreen mainScreen].bounds;
    
    UIWindow  *window = _handleVC.view.window;
    
    //隐藏状态栏
    window.windowLevel = UIWindowLevelStatusBar+10.0f;
    
    //添加视图（开始执行ViewDidLoad）
    [window addSubview:self.view];
    //添加控制器
    [self.handleVC addChildViewController:self];

    _scrollview.alpha = 0;
    
    [UIView animateWithDuration:0.35 animations:^{
        _scrollview.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    [self addImageView];
}

- (void)dismiss{
    
    [UIView animateWithDuration:0.35 animations:^{
        _scrollview.alpha = 0;
    } completion:^(BOOL finished) {
    
        [_scrollview removeFromSuperview];
        [self dismissEnd];
    }];
}

- (void)dismissEnd{
    
    self.view.window.windowLevel = UIWindowLevelNormal;//显示状态栏
    _handleVC =nil;
    self.photoModels = nil;
    //移除视图
    [self.view removeFromSuperview];
    self.view = nil;
    //移除
    [self removeFromParentViewController];
}


- (void)addImageView{
    
    if(_photoModels&&[_photoModels count]>0){
        UIImageView *imgView = nil;
        for (int i=0;i<[_photoModels count];i++) {
            imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, i*_scrollview.frame.size.width, _scrollview.frame.size.width, _scrollview.frame.size.width)];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            imgView.tag = kImageBaseTag + i;
            [_contentView addSubview:imgView];
            
            DSPhotoModel *photoModel = [_photoModels objectAtIndex:i];
            
            if (photoModel.image) {
                [imgView setImage:photoModel.image];
                CGSize size = photoModel.image.size;
                CGFloat showHeight = size.height*_contentView.frame.size.width/size.width;
                imgView.frame = CGRectMake(0.f,0.f,_contentView.frame.size.width,showHeight);
                [self performSelectorOnMainThread:@selector(refreshPicViewFrame) withObject:nil waitUntilDone:NO];
            }else{
                [imgView sd_setImageWithURL:[NSURL URLWithString:photoModel.image_HD_U] placeholderImage:[UIImage imageNamed:@"shang_pin_mo_ren_tu_pian"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image) {
                        CGSize size = image.size;
                        CGFloat showHeight = size.height*_contentView.frame.size.width/size.width;
                        imgView.frame = CGRectMake(0.f,0.f,_contentView.frame.size.width,showHeight);
                        [self performSelectorOnMainThread:@selector(refreshPicViewFrame) withObject:nil waitUntilDone:NO];
                    }
                }];
            }
        }
        if ([_photoModels count] == 1) {
            imgView.center = CGPointMake(_contentView.frame.size.width/2, _contentView.frame.size.height/2);
        }
    }
}

- (void)refreshPicViewFrame{
    
    if ([_photoModels count] == 1) {
        
        CGRect frame = self.scrollview.frame;
        
        UIImageView *imageview = (UIImageView*)[_contentView viewWithTag:kImageBaseTag];
        CGRect imageFrame = imageview.frame;
        
        //根据图片大小找到最大缩放等级，保证最大缩放时候，不会有黑边
        CGFloat maxScale = frame.size.height/imageFrame.size.height;
        maxScale = frame.size.width/imageFrame.size.width>maxScale?frame.size.width/imageFrame.size.width:maxScale;
        //超过了设置的最大的才算数
        maxScale = maxScale>kMaxZoomScale?maxScale:kMaxZoomScale;
        //初始
        
        self.scrollview.minimumZoomScale = 1;
        self.scrollview.maximumZoomScale = maxScale;
        self.scrollview.zoomScale = 1.0f;
        
        _contentView.frame = imageFrame;
        self.scrollview.contentSize = imageview.frame.size;
        _contentView.center = [self centerOfScrollViewContent:self.scrollview];
        imageview.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
        
        self.scrollview.contentOffset = CGPointZero;
    }else{
        float _offsetYY = 0;
        for(int i=0;i<[_contentView.subviews count];i++){
            UIImageView *view = (UIImageView*)[_contentView viewWithTag:kImageBaseTag+i];
            view.center = CGPointMake(_contentView.frame.size.width/2.f,_offsetYY+view.frame.size.height/2.f);
            _offsetYY+=view.bounds.size.height;
        }
        _contentView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _offsetYY);
        _scrollview.contentSize = CGSizeMake(_contentView.frame.size.width, _offsetYY);
    }
    
    if (_selectIndex && _selectIndex<[_photoModels count]) {
        UIImageView  *selectView = [_contentView viewWithTag:kImageBaseTag + _selectIndex];
        if (selectView) {
            if(selectView.center.y>_scrollview.contentSize.height - _scrollview.frame.size.height/2){
                
                _scrollview.contentOffset = CGPointMake(0, _scrollview.contentSize.height - _scrollview.frame.size.height);
            }else{
                
                _scrollview.contentOffset = CGPointMake(0, selectView.frame.origin.y);
            }
        }
    }
}

- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}

#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return self.contentView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView //这里是缩放进行时调整
{
    if ([_photoModels count] == 1) {
        self.contentView.center = [self centerOfScrollViewContent:self.scrollview];
    }
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
