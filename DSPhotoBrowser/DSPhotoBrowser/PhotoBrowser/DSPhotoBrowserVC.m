//
//  DSPhotoBrowserVC.m
//  DSPhotoBrowser
//
//  Created by dasheng on 16/1/14.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import "DSPhotoBrowserVC.h"
#import "DSPhotoBrowserView.h"
#import "DSPhotoModel.h"
#import "DSPhotoBrowserConfig.m"
#import "DSNavigationBarView.h"

@interface DSPhotoBrowserVC()<UIScrollViewDelegate>{
    
    UIScrollView         *_scrollView;        //主scrollView
    UIView               *_contentView;       //内容View
    DSNavigationBarView  *_navigationBarView; //顶部栏
    UILabel              *_indexLabel;        //照片张数及第几张label
    
    CGRect                _contentRect;       //内容栏的rect
}

@end

@implementation DSPhotoBrowserVC

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
    
    
    [self initNavigationBar];
    [self setupScrollView];
    [self initIndexLabel];
}


#pragma mark - Init Methon

- (void)initNavigationBar{
    
    if (self.isNavigationBar) {
        _navigationBarView = [[DSNavigationBarView alloc] init];
        _navigationBarView.backgroundColor = [UIColor whiteColor];
        _navigationBarView.alpha = 0;
        //返回的回调
        __weak __typeof(self)weakSelf = self;
        _navigationBarView.backBlock = ^(UIButton *sender){
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf dismiss];
        };
        [self.view addSubview:_navigationBarView];
        _contentRect = CGRectMake(0, _navigationBarView.frame.size.height, kAPPWidth, KAppHeight - _navigationBarView.frame.size.height);
    }else{
        _contentRect = self.view.bounds;
    }
}

//创建scrollView及上面的视图
- (void)setupScrollView{
    
    _contentView = [[UIView alloc] initWithFrame:_contentRect];
    [self.view addSubview:_contentView];
    
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounds = CGRectMake(0, 0, _contentRect.size.width + DSPhotoBrowserImageViewMargin * 2, _contentRect.size.height);
    _scrollView.center = CGPointMake(_contentRect.size.width *0.5, _contentRect.size.height *0.5);
    [_contentView addSubview:_scrollView];
    
    for (int i = 0; i < [self.photoModels count]; i++) {
        
        CGFloat x = DSPhotoBrowserImageViewMargin + i * (DSPhotoBrowserImageViewMargin * 2 + kAPPWidth);
        DSPhotoBrowserView *view = [[DSPhotoBrowserView alloc] initWithFrame:CGRectMake(x, 0, kAPPWidth, _scrollView.bounds.size.height)];
        view.imageview.tag = i;
        
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
        
        [view setImageWithURL:[NSURL URLWithString:photoModel.image_HD_U] placeholderImage:nil];
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
        case DSPhotoBrowserTypePush:
            
            break;
        case DSPhotoBrowserTypeTransform:
            break;
        case DSPhotoBrowserTypeFadeIn:{
            
            [self fadeInPhotoVC];
        }
            break;
        default:
            break;
    }
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
    
    
    //创建临时ImageView用于动画
    UIImageView *tempView = [[UIImageView alloc] init];
    //将rect由rect所在视图转换到目标视图view中，返回在目标视图view中的rect
    tempView.frame = [photoModel.sourceImageView convertRect:photoModel.sourceImageView.bounds toView:_contentView];
    tempView.image = [photoModel.sourceImageView.image copy];
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
        _navigationBarView.alpha = 1;
        
    } completion:^(BOOL finished) {
        //动画完成后，删除临时imageview，让目标imageview显示
        [tempView removeFromSuperview];
        _scrollView.hidden = NO;
        [self showIndexLabel];
        photoModel.sourceImageView.hidden = NO;
    }];
    
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)dismiss{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissAtIndex:)]) {
        
        [self.delegate dismissAtIndex:self.currentImageIndex];
    }
    
    switch (self.type) {
        case DSPhotoBrowserTypePush:
            
            break;
        case DSPhotoBrowserTypeTransform:
            break;
        case DSPhotoBrowserTypeFadeIn:
            [self dismissOutTypeFadeIn];
            break;
        default:
            break;
    }
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
    tempImageView.image = currentImageView.image;
    tempImageView.contentMode = photoModel.sourceImageView.contentMode;
    tempImageView.clipsToBounds = photoModel.sourceImageView.clipsToBounds;
    CGFloat tempImageSizeH = tempImageView.image.size.height;
    CGFloat tempImageSizeW = tempImageView.image.size.width;
    
    CGFloat tempImageViewH = (tempImageSizeH * kAPPWidth)/(tempImageSizeW?:0.1);
    if (tempImageViewH < _contentRect.size.height) {//图片高度<屏幕高度
        tempImageView.frame = CGRectMake(0, (_contentRect.size.height - tempImageViewH)*0.5, kAPPWidth, tempImageViewH);
    } else {
        tempImageView.frame = CGRectMake(0, 0, kAPPWidth, tempImageViewH);
    }
    [_contentView addSubview:tempImageView];
    
    
    photoModel.sourceImageView.hidden = YES;
    _scrollView.hidden = YES;
    _indexLabel.hidden = YES;
    self.view.backgroundColor = [UIColor clearColor];
    _contentView.backgroundColor = [UIColor clearColor];
    self.view.window.windowLevel = UIWindowLevelNormal;//显示状态栏
    
    //检查sourceF是否在屏幕里面
    CGRect screenF =[UIScreen mainScreen].bounds;
    BOOL isInScreen = CGRectIntersectsRect(targetTemp, screenF);
    if (isInScreen) {
        [UIView animateWithDuration:DSPhotoBrowserShowImageAnimationDuration animations:^{
            tempImageView.frame = targetTemp;
            _navigationBarView.alpha = 0;
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
            _navigationBarView.alpha = 0;
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

#pragma mark - Override

- (void)initIndexLabel{
    
    if(self.isIndexLabel){
        
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.font = [UIFont systemFontOfSize:20];
        _indexLabel.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.3f];
        _indexLabel.bounds = CGRectMake(0, 0, 80, 30);
        _indexLabel.center = CGPointMake(kAPPWidth * 0.5, 30);
        _indexLabel.layer.cornerRadius = 15;
        _indexLabel.clipsToBounds = YES;
        if ([self.photoModels count] > 1) {
            _indexLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)_currentImageIndex + 1,(long)[self.photoModels count]];
            [self.view addSubview:_indexLabel];
        }
    }
}

- (void)showIndexLabel{
    
    _indexLabel.hidden = NO;
}

- (void)hideIndexLabel{
    
    _indexLabel.hidden = YES;
}

- (void)setIndexLabelNumber:(NSInteger)index{
    
    _indexLabel.text = [NSString stringWithFormat:@"%ld/%ld", index + 1, (long)[self.photoModels count]];
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
