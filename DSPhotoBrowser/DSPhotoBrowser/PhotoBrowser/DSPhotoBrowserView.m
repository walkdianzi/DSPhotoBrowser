//
//  DSPhotoBrowserView.m
//  DSPhotoBrowser
//
//  Created by dasheng on 16/1/14.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import "DSPhotoBrowserView.h"
#import "DSWaitingView.h"
#import "DSPhotoBrowserConfig.m"
#import "UIImageView+WebCache.h"
#import "UIView+Toast.h"
#import "DSProgressView.h"

#define kProgressViewTag 123456
@interface DSPhotoBrowserView()<UIScrollViewDelegate, UIActionSheetDelegate>{
    
    UIActivityIndicatorView *_indicatorView;
    
}

@property (nonatomic,strong) DSWaitingView *waitingView;
@property (nonatomic,strong) UIImageView   *orginImageView;
@property (nonatomic,strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic,strong) UITapGestureRecognizer *singleTap;
@property (nonatomic,strong) UILongPressGestureRecognizer *longPressTap;
@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, strong) UIImage *placeHolderImage;
@property (nonatomic, strong) UIButton *reloadButton;

@end

@implementation DSPhotoBrowserView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.scrollview];
        //添加单双击事件
        [self addGestureRecognizer:self.doubleTap];
        [self addGestureRecognizer:self.singleTap];
        [self addGestureRecognizer:self.longPressTap];
    }
    return self;
}

- (UIScrollView *)scrollview
{
    if (!_scrollview) {
        _scrollview = [[UIScrollView alloc] init];
        _scrollview.frame = CGRectMake(0, 0, kAPPWidth, KAppHeight);
        [_scrollview addSubview:self.imageview];
        _scrollview.delegate = self;
        _scrollview.clipsToBounds = YES;
    }
    return _scrollview;
}

- (UIImageView *)imageview
{
    if (!_imageview) {
        _imageview = [[UIImageView alloc] init];
        _imageview.frame = CGRectMake(0, 0, kAPPWidth, KAppHeight);
        _imageview.userInteractionEnabled = YES;
    }
    return _imageview;
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

- (UILongPressGestureRecognizer *)longPressTap{
    
    if (!_longPressTap) {
        _longPressTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressTap:)];
        _longPressTap.minimumPressDuration = 1;
        _longPressTap.numberOfTouchesRequired = 1;
    }
    return _longPressTap;
}

#pragma mark 双击
- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    
    //图片加载完之后才能响应双击放大
    if (!self.hasLoadedImage) {
        return;
    }
    CGPoint touchPoint = [recognizer locationInView:self];
    if (self.scrollview.zoomScale <= 1.0) {
        
        CGFloat scaleX = touchPoint.x + self.scrollview.contentOffset.x;//需要放大的图片的X点
        CGFloat sacleY = touchPoint.y + self.scrollview.contentOffset.y;//需要放大的图片的Y点
        [self.scrollview zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
        
    } else {
        [self.scrollview setZoomScale:1.0 animated:YES]; //还原
    }
}

#pragma mark 单击
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    if (self.singleTapBlock) {
        self.singleTapBlock(recognizer);
    }
}

#pragma mark 长按

- (void)handleLongPressTap:(UILongPressGestureRecognizer *)recognizer{
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        return;
        
    } else if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        UIActionSheet * myActionSheet = [[UIActionSheet alloc]
                                         initWithTitle:nil
                                         delegate:self
                                         cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                         otherButtonTitles:@"保存图片", nil];
        [myActionSheet showInView:self];
    }
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    _waitingView.progress = progress;
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder{
    
    [self setImageWithURL:url placeholderImage:placeholder withOrginImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder withOrginImage:(UIImageView *)orginImageView{
    
    //微信里用到的小原图，加载失败的时候点击重新加载，orginImageView为nil，不会执行下面这段
    if (orginImageView != nil) {

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, orginImageView.frame.size.width, orginImageView.frame.size.height)];
        imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [imageView setImage:orginImageView.image];
        imageView.contentMode = orginImageView.contentMode;     //mode为原小图的mode
        imageView.clipsToBounds = orginImageView.clipsToBounds;
        
        UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
        maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
        [imageView addSubview:maskView];
        
        self.orginImageView = imageView;
        [self addSubview:imageView];
    }
    
    if (_reloadButton) {
        [_reloadButton removeFromSuperview];
    }
    _imageUrl = url;
    _placeHolderImage = placeholder;
    
    if (self.type != DSPhotoBrowserTypeWeChat) {
        //添加进度指示器
        DSWaitingView *waitingView = [[DSWaitingView alloc] init];
        waitingView.mode = DSWaitingViewModeLoopDiagram;
        waitingView.center = CGPointMake(kAPPWidth * 0.5, KAppHeight * 0.5);
        self.waitingView = waitingView;
        [self addSubview:waitingView];
    }else{
        DSProgressView *progressCircleView = [[DSProgressView alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 32/2, self.frame.size.height/2 - 32/2, 32, 32)];
        progressCircleView.tag = kProgressViewTag;
        [self addSubview:progressCircleView];
        [progressCircleView startAnimation];
    }
    //HZWebImage加载图片
    __weak __typeof(self)weakSelf = self;
    [_imageview sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (self.type != DSPhotoBrowserTypeWeChat) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.waitingView.progress = (CGFloat)receivedSize / expectedSize;
        }
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.waitingView removeFromSuperview];
        __weak DSProgressView *progressCircleView = [self viewWithTag:kProgressViewTag];
        if (progressCircleView) {
            [progressCircleView stopAnimation];
            [progressCircleView removeFromSuperview];
        }
        if (error) {
            //图片加载失败的处理，此处可以自定义各种操作（...）
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            strongSelf.reloadButton = button;
            button.layer.cornerRadius = 2;
            button.clipsToBounds = YES;
            button.bounds = CGRectMake(0, 0, 200, 40);
            button.center = CGPointMake(kAPPWidth * 0.5, KAppHeight * 0.5);
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.3f];
            [button setTitle:@"原图加载失败，点击重新加载" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:strongSelf action:@selector(reloadImage) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:button];
            return;
        }
        if (strongSelf.orginImageView) {
            [strongSelf.imageview setHidden:YES];
            strongSelf.orginImageView.contentMode = UIViewContentModeScaleAspectFit;
            for (UIView *subview in strongSelf.orginImageView.subviews) {
                [subview removeFromSuperview];
            }
            [UIView animateWithDuration:DSPhotoBrowserShowImageAnimationDuration animations:^{
                
                strongSelf.orginImageView.frame = strongSelf.imageview.frame;
            } completion:^(BOOL finished) {
                [strongSelf.imageview setHidden:NO];
                [strongSelf.orginImageView removeFromSuperview];
            }];
        }
        strongSelf.hasLoadedImage = YES;//图片加载成功
    }];
}

- (void)reloadImage{
    
    [self setImageWithURL:_imageUrl placeholderImage:_placeHolderImage];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _waitingView.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    _scrollview.frame = self.bounds;
    _waitingView.center = _scrollview.center;
    [self adjustFrame];
}

- (void)adjustFrame
{
    CGRect frame = self.scrollview.frame;
    if (self.imageview.image) {
        CGSize imageSize = self.imageview.image.size;//获得图片的size
        CGRect imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        if (kIsFullWidthForLandScape) {//图片宽度始终==屏幕宽度(新浪微博就是这种效果)
            CGFloat ratio = frame.size.width/imageFrame.size.width;
            imageFrame.size.height = imageFrame.size.height*ratio;
            imageFrame.size.width = frame.size.width;
        } else{
            if (frame.size.width<=frame.size.height) {
                //竖屏时候
                CGFloat ratio = frame.size.width/imageFrame.size.width;
                imageFrame.size.height = imageFrame.size.height*ratio;
                imageFrame.size.width = frame.size.width;
            }else{ //横屏的时候
                CGFloat ratio = frame.size.height/imageFrame.size.height;
                imageFrame.size.width = imageFrame.size.width*ratio;
                imageFrame.size.height = frame.size.height;
            }
        }
        
        self.imageview.frame = imageFrame;
        //        NSLog(@"%@",NSStringFromCGRect(_scrollview.frame));
        //        NSLog(@"%@",NSStringFromCGRect(self.imageview.frame));
        //        self.scrollview.frame = self.imageview.frame;
        self.scrollview.contentSize = self.imageview.frame.size;
        self.imageview.center = [self centerOfScrollViewContent:self.scrollview];
        
        //根据图片大小找到最大缩放等级，保证最大缩放时候，不会有黑边
        CGFloat maxScale = frame.size.height/imageFrame.size.height;
        maxScale = frame.size.width/imageFrame.size.width>maxScale?frame.size.width/imageFrame.size.width:maxScale;
        //超过了设置的最大的才算数
        maxScale = maxScale>kMaxZoomScale?maxScale:kMaxZoomScale;
        //初始化
        self.scrollview.minimumZoomScale = kMinZoomScale;
        self.scrollview.maximumZoomScale = maxScale;
        self.scrollview.zoomScale = 1.0f;
    }else{
        frame.origin = CGPointZero;
        self.imageview.frame = frame;
        //重置内容大小
        self.scrollview.contentSize = self.imageview.frame.size;
    }
    self.scrollview.contentOffset = CGPointZero;
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
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageview;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView //这里是缩放进行时调整
{
    self.imageview.center = [self centerOfScrollViewContent:scrollView];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            [self saveImage];
            break;
        default:
            break;
    }
}

#pragma mark 保存图像
- (void)saveImage
{
    
    UIImageWriteToSavedPhotosAlbum(self.imageview.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = self.center;
    _indicatorView = indicator;
    [[UIApplication sharedApplication].keyWindow addSubview:indicator];
    [indicator startAnimating];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [_indicatorView removeFromSuperview];
    
    if (error) {
        [self makeToast:@"保存失败" duration:kToastTime position:@"center"];
    }else {
        [self makeToast:@"保存成功" duration:kToastTime position:@"center"];
    }
}

@end
