//
//  WXPhotoBrowserVC.m
//  DSPhotoBrowser
//
//  Created by dasheng on 16/1/18.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import "WXPhotoBrowserVC.h"
#import "StyledPageControl.h"
#import "DSPhotoBrowserView.h"
#import "DSPhotoModel.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
@interface WXPhotoBrowserVC()<UIScrollViewDelegate>{
    
    UIScrollView         *_scrollView;        //主scrollView
    UIView               *_contentView;       //内容View
    StyledPageControl    *_pageControl;       //照片张数及第几张label
    
    CGRect                _contentRect;       //内容栏的rect
    
    
    BOOL                  _lastVCNavigationBarHidden;
}

@end

@implementation WXPhotoBrowserVC

- (instancetype)init{
    
    self = [super init];
    if (self) {
        _isNavigationBar = NO;
        _isIndexLabel = YES;
    }
    return self;
}


- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    _contentRect = self.view.bounds;
    [self setupScrollView];
    [self initIndexLabel];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    _lastVCNavigationBarHidden = _handleVC.navigationController.navigationBarHidden;
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:_lastVCNavigationBarHidden];
}

#pragma mark - Init Methon

//创建scrollView及上面的视图
- (void)setupScrollView{
    
    _contentView = [[UIView alloc] initWithFrame:_contentRect];
    [self.view addSubview:_contentView];
    
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.frame = CGRectMake(0, 0, _contentRect.size.width + DSPhotoBrowserImageViewMargin * 2, _contentRect.size.height);
    _scrollView.center = CGPointMake(_contentRect.size.width *0.5, _contentRect.size.height *0.5);
    [self.view addSubview:_scrollView];
    
    for (int i = 0; i < [self.photoModels count]; i++) {
        
        CGFloat x = DSPhotoBrowserImageViewMargin + i * (DSPhotoBrowserImageViewMargin * 2 + kAPPWidth);
        DSPhotoBrowserView *view = [[DSPhotoBrowserView alloc] initWithFrame:CGRectMake(x, 0, kAPPWidth, _scrollView.bounds.size.height)];
        view.imageview.tag = i;
        view.type = self.type;
        //处理单击
        __weak __typeof(self)weakSelf = self;
        view.singleTapBlock = ^(UITapGestureRecognizer *recognizer){
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf photoClick:recognizer];
        };
        [_scrollView addSubview:view];
    }
    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, _scrollView.frame.size.height);
    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
    
    [self setupImageOfImageViewForIndex:self.currentImageIndex];
}

// 加载图片对应位置的图片
- (void)setupImageOfImageViewForIndex:(NSInteger)index{
    
    DSPhotoModel *photoModel = [self.photoModels objectAtIndex:index];
    
    if (index < [_scrollView.subviews count]) {
        DSPhotoBrowserView *view = _scrollView.subviews[index];
        if (view.beginLoadingImage) return;
        
        //判断是否有缓存，如果有缓存，则直接执行放大动画
        if (([[SDImageCache sharedImageCache] diskImageExistsWithKey:photoModel.image_HD_U])) {
            [view setImageWithURL:[NSURL URLWithString:photoModel.image_HD_U] placeholderImage:nil];
        }else{
            [view setImageWithURL:[NSURL URLWithString:photoModel.image_HD_U] placeholderImage:nil withOrginImage:photoModel.sourceImageView];
        }
        view.beginLoadingImage = YES;
    }
}

#pragma mark - Click Methon

//单击图片
- (void)photoClick:(UITapGestureRecognizer *)recognizer{
    
    [self dismiss];
}


#pragma mark - Other Methon

- (void)show{
    
    switch (_type) {
        case DSPhotoBrowserTypePush:{
            [self pushInPhotoVC];
        }
            break;
        case DSPhotoBrowserTypeTransform:
            break;
        case DSPhotoBrowserTypeFadeIn:{
            
            [self fadeInPhotoVC];
        }
            break;
        case DSPhotoBrowserTypeWeChat:{
            [self fadeInPhotoVC];
        }
            break;
        default:
            break;
    }
}

- (void)pushInPhotoVC{
    
    if (!_handleVC) {
        return;
    }
    //当前view的大小为屏幕的大小
    self.view.frame = [UIScreen mainScreen].bounds;
    
    
    UIWindow  *window = _handleVC.view.window;
    if (!self.isNavigationBar) {
        //隐藏状态栏
        window.windowLevel = UIWindowLevelStatusBar+10.0f;
    }
    self.view.backgroundColor = [UIColor blackColor];
    
    [_handleVC.navigationController pushViewController:self animated:YES];
}

- (void)fadeInPhotoVC{
    
    if (!_handleVC) {
        return;
    }
    //当前view的大小为屏幕的大小
    self.view.frame = [UIScreen mainScreen].bounds;
    
    UIWindow  *window = _handleVC.view.window;
    if (!self.isNavigationBar) {
        //隐藏状态栏
        window.windowLevel = UIWindowLevelStatusBar+10.0f;
    }
    //添加视图（开始执行ViewDidLoad）
    [window addSubview:self.view];
    //添加控制器
    [self.handleVC addChildViewController:self];
    
    
    //先隐藏源ImageView
    DSPhotoModel *photoModel = [self.photoModels objectAtIndex:self.currentImageIndex];
    photoModel.sourceImageView.hidden = YES;
    
    if ([[SDImageCache sharedImageCache] diskImageExistsWithKey:photoModel.image_HD_U]) {
        
        //创建临时ImageView用于动画
        UIImageView *tempView = [[UIImageView alloc] init];
        //将rect由rect所在视图转换到目标视图view中，返回在目标视图view中的rect
        tempView.frame = [photoModel.sourceImageView convertRect:photoModel.sourceImageView.bounds toView:_contentView];
        [tempView sd_setImageWithURL:[NSURL URLWithString:photoModel.image_HD_U] placeholderImage:photoModel.sourceImageView.image options:SDWebImageRetryFailed];
        tempView.contentMode = UIViewContentModeScaleAspectFit;
        [_contentView addSubview:tempView];
        
        CGFloat placeImageSizeW = tempView.image.size.width;
        CGFloat placeImageSizeH = tempView.image.size.height;
        CGRect targetTemp;
        CGFloat placeHolderH = (placeImageSizeH * kAPPWidth)/(placeImageSizeW?:0.1);
        if (placeHolderH <= _contentRect.size.height) {
            targetTemp = CGRectMake(0, (_contentRect.size.height - placeHolderH) * 0.5 , kAPPWidth, placeHolderH);
        } else {//图片高度>屏幕高度
            targetTemp = CGRectMake(0, 0, kAPPWidth, placeHolderH);
        }
        
        //先隐藏scrollview
        _scrollView.hidden = YES;
        [self hideIndexLabel];
        
        [UIView animateWithDuration:DSPhotoBrowserShowImageAnimationDuration animations:^{
            //将点击的临时imageview动画放大到和目标imageview一样大
            tempView.frame = targetTemp;
            
        } completion:^(BOOL finished) {
            //动画完成后，删除临时imageview，让目标imageview显示
            [tempView removeFromSuperview];
            _scrollView.hidden = NO;
            [self showIndexLabel];
            photoModel.sourceImageView.hidden = NO;
        }];
        
        self.view.backgroundColor = [UIColor blackColor];
    }else{
        _scrollView.hidden = NO;
        [self showIndexLabel];
        photoModel.sourceImageView.hidden = NO;
        self.view.backgroundColor = [UIColor blackColor];
    }
}


- (void)dismiss{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissAtIndex:)]) {
        
        [self.delegate dismissAtIndex:self.currentImageIndex];
    }
    
    switch (self.type) {
        case DSPhotoBrowserTypePush:
            [self dismissOutTypePush];
            break;
        case DSPhotoBrowserTypeTransform:
            break;
        case DSPhotoBrowserTypeFadeIn:case DSPhotoBrowserTypeWeChat:
            [self dismissOutTypeFadeIn];
            break;
        default:
            break;
    }
}

- (void)dismissOutTypePush{
    
    self.view.window.windowLevel = UIWindowLevelNormal;//显示状态栏
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismissOutTypeFadeIn{
    
    DSPhotoBrowserView *view;
    DSPhotoModel *photoModel;
    if (self.currentImageIndex < [_scrollView.subviews count]) {
        
        photoModel = [self.photoModels objectAtIndex:self.currentImageIndex];
        view = _scrollView.subviews[self.currentImageIndex];
    }else{
        [self dismissEnd];
    }
    UIImageView *currentImageView = view.imageview;
    
    
    CGRect targetTemp = [photoModel.sourceImageView convertRect:photoModel.sourceImageView.bounds toView:_contentView];
    //创建临时ImageView用于动画
    UIImageView *tempImageView = [[UIImageView alloc] init];
    tempImageView.contentMode = photoModel.sourceImageView.contentMode;
    tempImageView.clipsToBounds = photoModel.sourceImageView.clipsToBounds;
    
    //已经有缓存，则从大图动画到小图。无缓存，还是从小图到小图
    if ([[SDImageCache sharedImageCache] diskImageExistsWithKey:photoModel.image_HD_U]) {
        tempImageView.image = currentImageView.image;
        CGFloat tempImageSizeH = tempImageView.image.size.height;
        CGFloat tempImageSizeW = tempImageView.image.size.width;
        CGFloat tempImageViewH = (tempImageSizeH * kAPPWidth)/(tempImageSizeW?:0.1);
        if (tempImageViewH < _contentRect.size.height) {//图片高度<屏幕高度
            tempImageView.frame = CGRectMake(0, (_contentRect.size.height - tempImageViewH)*0.5, kAPPWidth, tempImageViewH);
        } else {
            tempImageView.frame = CGRectMake(0, 0, kAPPWidth, tempImageViewH);
        }
    }else{
        tempImageView.image = photoModel.sourceImageView.image;
        tempImageView.frame = CGRectMake((kAPPWidth - targetTemp.size.width)/2, (_contentRect.size.height - targetTemp.size.height)*0.5, targetTemp.size.width, targetTemp.size.height);
    }
    [_contentView addSubview:tempImageView];
    
    
    photoModel.sourceImageView.hidden = YES;
    _scrollView.hidden = YES;
    _pageControl.hidden = YES;
    self.view.backgroundColor = [UIColor clearColor];
    _contentView.backgroundColor = [UIColor clearColor];
    self.view.window.windowLevel = UIWindowLevelNormal;//显示状态栏
    
    //检查sourceF是否在屏幕里面
    CGRect screenF =[UIScreen mainScreen].bounds;
    BOOL isInScreen = CGRectIntersectsRect(targetTemp, screenF);
    if (isInScreen) {
        [UIView animateWithDuration:DSPhotoBrowserShowImageAnimationDuration animations:^{
            tempImageView.frame = targetTemp;
        } completion:^(BOOL finished) {
            
            photoModel.sourceImageView.hidden = NO;
            [_contentView removeFromSuperview];
            [tempImageView removeFromSuperview];
            [self dismissEnd];
        }];
    }else{
        
        [UIView animateWithDuration:DSPhotoBrowserShowImageAnimationDuration animations:^{
            
            _contentView.alpha = 0;
            tempImageView.alpha = 0;
        } completion:^(BOOL finished) {
            
            photoModel.sourceImageView.hidden = NO;
            [_contentView removeFromSuperview];
            [tempImageView removeFromSuperview];
            [self dismissEnd];
        }];
    }
}

- (void)dismissEnd{
    
    _handleVC =nil;
    self.photoModels = nil;
    //移除视图
    [self.view removeFromSuperview];
    self.view = nil;
    //移除
    [self removeFromParentViewController];
}


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

#pragma mark - Delegate

#pragma mark scrollview代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
    
    [self setIndexLabelNumber:index];
    
    long left = index - 1;
    long right = index + 1;
    left = left>0?left : 0;
    right = right>[self.photoModels count]?:right;
    
    for (long i = left; i < right; i++) {
        [self setupImageOfImageViewForIndex:i];
    }
}

//scrollview结束滚动调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int autualIndex = scrollView.contentOffset.x  / _scrollView.bounds.size.width;
    //设置当前下标
    self.currentImageIndex = autualIndex;
    //将不是当前imageview的缩放全部还原 (这个方法有些冗余，后期可以改进)
    for (DSPhotoBrowserView *view in _scrollView.subviews) {
        if (view.imageview.tag != autualIndex) {
            view.scrollview.zoomScale = 1.0;
        }
    }
}
@end
