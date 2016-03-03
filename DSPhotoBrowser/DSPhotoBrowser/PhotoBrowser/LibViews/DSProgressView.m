//
//  DSProgressView.m
//  DSPhotoBrowser
//
//  Created by 橙子 on 16/3/1.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import "DSProgressView.h"

#define DEFAULT_LINE_WIDTH 4.0
#define ROUND_TIME 0.75

@interface DSProgressView ()

@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) CAAnimation *rotationAnimation;


@end

@implementation DSProgressView

- (instancetype)init {
    self = [super init];
    if(self) {
        [self initialSetup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initialSetup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self initialSetup];
    }
    return self;
}

#pragma mark - Initial Setup
- (void)initialSetup{

    self.backgroundLayer = [CAShapeLayer layer];
    self.circleLayer = [CAShapeLayer layer];
    
    [self.layer addSublayer:self.backgroundLayer];
    [self.layer addSublayer:self.circleLayer];
    
    
    self.backgroundLayer.fillColor = nil;
    self.backgroundLayer.lineWidth = DEFAULT_LINE_WIDTH;
    self.backgroundLayer.lineCap = kCALineCapRound;
    
    self.circleLayer.fillColor = nil;
    self.circleLayer.lineWidth = DEFAULT_LINE_WIDTH;
    self.circleLayer.lineCap = kCALineCapRound;
    
    
    [self updateAnimations];

}

- (void)updateAnimations
{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.fromValue = @0;
    rotationAnimation.toValue = @(2*M_PI);
    rotationAnimation.duration = ROUND_TIME;
    rotationAnimation.repeatCount = INFINITY;
    self.rotationAnimation = rotationAnimation;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    self.circleLayer.lineWidth = _lineWidth;
    self.backgroundLayer.lineWidth = _lineWidth;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    

    
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height)/2.0 - self.circleLayer.lineWidth / 2.0;
    CGFloat startAngle = 0;
    CGFloat endAngle = 2*M_PI;
    
    UIBezierPath *backgroundLayerPath = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:startAngle
                                                      endAngle:endAngle
                                                     clockwise:YES];
    
    self.backgroundLayer.path = backgroundLayerPath.CGPath;
    self.backgroundLayer.strokeColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6].CGColor;
    self.backgroundLayer.frame = self.bounds;
    
    endAngle = 2*M_PI/3;
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:center
                                                              radius:radius
                                                          startAngle:startAngle endAngle:endAngle clockwise:YES];
    self.circleLayer.path = circlePath.CGPath;
    self.circleLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.circleLayer.frame = self.bounds;
    
}


- (void)startAnimation {
    [self.circleLayer addAnimation:self.rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopAnimation {
    [self.circleLayer removeAnimationForKey:@"rotationAnimation"];
}

- (void)dealloc {
    [self stopAnimation];
    [self.circleLayer removeFromSuperlayer];
    self.circleLayer = nil;
    [self.backgroundLayer removeFromSuperlayer];
    self.backgroundLayer = nil;
    self.rotationAnimation = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
