//
//  AnimationView.m
//  parkingTest
//
//  Created by zhanghangzhen on 16/3/29.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "AnimationView.h"

@interface AnimationView ()


@property (strong,nonatomic)CAShapeLayer *topLineLayer;
@property (strong,nonatomic)CAShapeLayer *bottomLineLayer;

@property (strong,nonatomic)CAShapeLayer *changeLineLayer;

@end

static const CGFloat raduis = 50.0f;
static const CGFloat lineWidth = 50.0f;
static const CGFloat lineGapHeight = 10.0f;
static const CGFloat lineHeight = 8.0f;


static const CGFloat Kstep1Dration = 0.5;
static const CGFloat Kstep2Dration = 0.5;
static const CGFloat Kstep3Dration = 5.0;
static const CGFloat Kstep4Dration = 5.0;


#define ktopY     raduis - lineGapHeight
#define kcenterY  ktopY + lineGapHeight + lineHeight
#define kbottom   kcenterY + lineGapHeight + lineHeight
#define RaDians(x)   (M_PI *(x)/180.0)


@implementation AnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor orangeColor];
    }
    return self;
}
-(void)startAnimation{

    [_changeLineLayer removeAllAnimations];
    [_changeLineLayer removeFromSuperlayer];
    [_topLineLayer removeFromSuperlayer];
    [_bottomLineLayer removeFromSuperlayer];
    
    [self initLayers];
    [self animationStep1];
}
//画两条横线
-(void)initLayers{

    _topLineLayer = [CAShapeLayer layer];
    _bottomLineLayer = [CAShapeLayer layer];
    _topLineLayer = [CAShapeLayer layer];

    CALayer *topLayer = [CALayer layer];
    topLayer.frame = CGRectMake((self.bounds.size.width + lineWidth)/2 , ktopY, lineWidth, lineHeight);
     [self.layer addSublayer:topLayer];
    
    CALayer *buttomLayer = [CALayer layer];
    topLayer.frame = CGRectMake((self.bounds.size.width + lineWidth)/2 , kbottom, lineWidth, lineHeight);
     [self.layer addSublayer:buttomLayer];

    CGFloat startOriginX = self.center.x - lineWidth /2.0;
    CGFloat endOriginX = self.center.x + lineWidth /2.0;

    [_topLineLayer setStrokeColor:[[UIColor whiteColor]CGColor]];
    _topLineLayer.contentsScale = [UIScreen mainScreen].scale;
    _topLineLayer.lineWidth = lineWidth;
     _topLineLayer.lineCap = kCALineCapRound;
    _topLineLayer.position = CGPointMake(0, 0);
    
    
    [_bottomLineLayer setStrokeColor:[[UIColor blackColor]CGColor]];
    _bottomLineLayer.contentsScale = [UIScreen mainScreen].scale;
    _bottomLineLayer.lineWidth = lineHeight;
    _bottomLineLayer.lineCap = kCALineCapRound;
    
    
    [_changeLineLayer setStrokeColor:[[UIColor purpleColor]CGColor]];
    _changeLineLayer.fillColor = [UIColor clearColor].CGColor;
    _changeLineLayer.contentsScale = [UIScreen mainScreen].scale;
    _changeLineLayer.lineWidth = lineHeight;
    _changeLineLayer.lineCap = kCALineCapRound;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(-lineWidth, 0)];
    _topLineLayer.path = path.CGPath;
    
    CGMutablePathRef solidchangedlinePath = CGPathCreateMutable();
    //被改变的layer实线
    CGPathMoveToPoint(solidchangedlinePath, NULL, startOriginX, kcenterY);
    
    CGPathAddLineToPoint(solidchangedlinePath, NULL, endOriginX, kcenterY);
    
    
    [_changeLineLayer setPath:solidchangedlinePath];
    CGPathRelease(solidchangedlinePath);
    
    
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(-lineWidth, 0)];
    _bottomLineLayer.path = path.CGPath;
    
    [topLayer addSublayer:_topLineLayer];
    [buttomLayer addSublayer:_bottomLineLayer];
    [self.layer addSublayer:_changeLineLayer];
}

-(void)animationStep1{
    _changeLineLayer.strokeEnd = 0.4;
    CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    strokeAnimation.toValue = [NSNumber numberWithFloat:0.4f];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    pathAnimation.toValue = [NSNumber numberWithFloat:-10];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:strokeAnimation,pathAnimation, nil];
    
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    animationGroup.duration = Kstep1Dration;
    animationGroup.delegate = self;
    animationGroup.removedOnCompletion = YES;
    [animationGroup setValue:@"animationStep1" forKey:@"animationName"];
    
    [_changeLineLayer addAnimation:animationGroup forKey:nil];
    
}
-(void)resumeAnimation{
    [self resumeLayer:_topLineLayer];
    [self resumeLayer:_bottomLineLayer];
    [self resumeLayer:_changeLineLayer];

}
-(void)resumeLayer:(CALayer*)layer{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
 }
-(void)stopAnimation{
    [self pauseLayer:_topLineLayer];
    [self pauseLayer:_bottomLineLayer];
     [self pauseLayer:_changeLineLayer];
 }
-(void)pauseLayer:(CALayer*)l{

    CFTimeInterval pauseTime = [l timeOffset];
    l.speed = 1.5;
    l.timeOffset = 0.1;
    l.beginTime = 0.0;
    CFTimeInterval timeSincePause = [l convertTime:CACurrentMediaTime() fromLayer:nil] - pauseTime;
    l.beginTime = timeSincePause;
  }
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    if ([[anim valueForKey:@"animationName"] isEqualToString:@"animationStep1"]) {
        
        [self animationStep2];
        
    }
    else if([[anim valueForKey:@"animationName"] isEqualToString:@"animationStep2"]){
        [_changeLineLayer removeFromSuperlayer];
        [self animationStep3];
    }
    else if ([[anim valueForKey:@"animationName"] isEqualToString:@"animationStep3"]){
        [self cancelAnimation];
    }
    else if ([[anim valueForKey:@"animationName"] isEqualToString:@"animationStep4"]){
        
        _changeLineLayer.affineTransform = CGAffineTransformMakeTranslation(5, 0);
        //平移x
        CABasicAnimation *translationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
        translationAnimation.fromValue = [NSNumber numberWithFloat:0];
        translationAnimation.toValue = [NSNumber numberWithFloat:5];
         translationAnimation.duration = 0.5;
        translationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [_changeLineLayer addAnimation:translationAnimation forKey:nil];
    }
 }
-(void)animationStep2{

    CABasicAnimation *translationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    translationAnimation.fromValue = [NSNumber numberWithFloat:-10];
    //strokeEnd:0.8 剩余的距离toValue = lineWidth * (1 - 0.8);
    translationAnimation.toValue = [NSNumber numberWithFloat:0.2 * lineWidth];
    
    _changeLineLayer.strokeEnd = 0.8;
    CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeAnimation.fromValue = [NSNumber numberWithFloat:0.4f];
    strokeAnimation.toValue = [NSNumber numberWithFloat:0.8f];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:strokeAnimation,translationAnimation, nil];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animationGroup.duration = Kstep2Dration;
    animationGroup.delegate = self;
    animationGroup.removedOnCompletion = YES;
    [animationGroup setValue:@"animationStep2" forKey:@"animationName"];
    [_changeLineLayer addAnimation:animationGroup forKey:nil];
}
-(void)animationStep3{
    _changeLineLayer = [CAShapeLayer layer];
    _changeLineLayer.fillColor = [UIColor clearColor].CGColor;
    _changeLineLayer.strokeColor = [UIColor whiteColor].CGColor;
    _changeLineLayer.contentsScale = [UIScreen mainScreen].scale;
    _changeLineLayer.lineWidth = lineHeight ;
    _changeLineLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:_changeLineLayer];
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // 画贝塞尔曲线 圆弧
    [path moveToPoint:CGPointMake(self.center.x +  lineWidth/2.0 , kcenterY)];
    
    //30度,经过反复测试，效果最好
    CGFloat angle = RaDians(30);
    
    CGFloat endPointX = self.center.x + raduis * cos(angle);
    CGFloat endPointY = kcenterY - raduis * sin(angle);
    
    CGFloat startPointX = self.center.x + lineWidth/2.0;
    CGFloat startPointY = kcenterY;
    
    CGFloat controlPointX = self.center.x + raduis *acos(angle);
    CGFloat controlPointY = kcenterY;
    
    //三点曲线
    [path addCurveToPoint:CGPointMake(endPointX, endPointY)
            controlPoint1:CGPointMake(startPointX , startPointY)
            controlPoint2:CGPointMake(controlPointX , controlPointY)];
    
    //组合path 路径
    UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x,kcenterY)
                                                         radius:raduis
                                                     startAngle:2 * M_PI - angle
                                                       endAngle:M_PI + angle
                                                      clockwise:NO];
    [path appendPath:path1];
    
    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x,kcenterY)
                                                         radius:raduis
                                                     startAngle:M_PI *3/2 - (M_PI_2 -angle)
                                                       endAngle:-M_PI_2 - (M_PI_2 -angle)
                                                      clockwise:NO];
    
    
    [path appendPath:path2];
    
    _changeLineLayer.path = path.CGPath;
    
    
    
    //平移量
    CGFloat toValue = lineWidth *(1- cos(M_PI_4)) /2.0;
    //finished 最终状态
    CGAffineTransform transform1 = CGAffineTransformMakeRotation(-M_PI_4);
    CGAffineTransform transform2 = CGAffineTransformMakeTranslation(-toValue, 0);
    CGAffineTransform transform3 = CGAffineTransformMakeRotation(M_PI_4);
    
    CGAffineTransform transform = CGAffineTransformConcat(transform1, transform2);
    _topLineLayer.affineTransform = transform;
    transform = CGAffineTransformConcat(transform3, transform2);
    _bottomLineLayer.affineTransform = transform;
    
    
    
    CGFloat orignPercent = [self calculateCurveLength] / [self calculateTotalLength];
    CGFloat endPercent =([self calculateCurveLength] + RaDians(120) *raduis ) / [self calculateTotalLength];
    
    _changeLineLayer.strokeStart = endPercent;
    
    CAKeyframeAnimation *startAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
    startAnimation.values = @[@0.0,@(endPercent)];
    
    CAKeyframeAnimation *EndAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    EndAnimation.values = @[@(orignPercent),@1.0];
    
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:startAnimation,EndAnimation, nil];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animationGroup.duration = Kstep3Dration;
    animationGroup.delegate = self;
    animationGroup.removedOnCompletion = YES;
    [animationGroup setValue:@"animationStep3" forKey:@"animationName"];
    [_changeLineLayer addAnimation:animationGroup forKey:nil];
    
    //平移x
    CABasicAnimation *translationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    translationAnimation.fromValue = [NSNumber numberWithFloat:0];
    translationAnimation.toValue = [NSNumber numberWithFloat:-toValue];
    
    //角度关键帧 上横线的关键帧 0 - 10° - (-55°) - (-45°)
    CAKeyframeAnimation *rotationAnimation1 = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation1.values = @[[NSNumber numberWithFloat:0],
                                  [NSNumber numberWithFloat:RaDians(10) ],
                                  [NSNumber numberWithFloat:RaDians(-10) - M_PI_4 ],
                                  [NSNumber numberWithFloat:- M_PI_4 ]
                                  ];
    
    
    CAAnimationGroup *transformGroup1 = [CAAnimationGroup animation];
    transformGroup1.animations = [NSArray arrayWithObjects:rotationAnimation1,translationAnimation, nil];
    transformGroup1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transformGroup1.duration = Kstep3Dration;
    transformGroup1.removedOnCompletion = YES;
    [_topLineLayer addAnimation:transformGroup1 forKey:nil];
    
    //角度关键帧 下横线的关键帧 0 - （-10°） - (55°) - (45°)
    CAKeyframeAnimation *rotationAnimation2 = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation2.values = @[[NSNumber numberWithFloat:0],
                                  [NSNumber numberWithFloat:RaDians(-10) ],
                                  [NSNumber numberWithFloat:RaDians(10) + M_PI_4 ],
                                  [NSNumber numberWithFloat: M_PI_4 ]
                                  ];
    
    
    CAAnimationGroup *transformGroup2 = [CAAnimationGroup animation];
    transformGroup2.animations = [NSArray arrayWithObjects:rotationAnimation2,translationAnimation, nil];
    transformGroup2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transformGroup2.duration = Kstep3Dration ;
    transformGroup2.delegate = self;
    transformGroup2.removedOnCompletion = YES;
    [_bottomLineLayer addAnimation:transformGroup2 forKey:nil];

    
}
-(CGFloat)calculateTotalLength
{
    
    CGFloat curveLength = [self calculateCurveLength];
    
    //一个圆 + 120度弧长的 总长度
    CGFloat length = (RaDians(120) + 2 * M_PI) * raduis;
    CGFloat totalLength = curveLength + length;
    
    return totalLength;
}
-(CGFloat)calculateCurveLength{
    
    CGFloat angle = RaDians(30);
    
    CGFloat endPointX = self.center.x + raduis * cos(angle);
    CGFloat endPointY = kcenterY - raduis * sin(angle);
    
    CGFloat startPointX = self.center.x + lineWidth/2.0;
    CGFloat startPointY = kcenterY;
    
    CGFloat controlPointX = self.center.x + raduis *acos(angle);
    CGFloat controlPointY = kcenterY;
    
    CGFloat curveLength = [self bezierCurveLengthFromStartPoint:CGPointMake(startPointX, startPointY)
                                                     toEndPoint:CGPointMake(endPointX,endPointY)
                                               withControlPoint:CGPointMake(controlPointX, controlPointY)];
    
    return curveLength;
}
-(CGFloat) bezierCurveLengthFromStartPoint:(CGPoint)start toEndPoint:(CGPoint) end withControlPoint:(CGPoint) control
{
    const int kSubdivisions = 50;
    const float step = 1.0f/(float)kSubdivisions;
    
    float totalLength = 0.0f;
    CGPoint prevPoint = start;
    
    // starting from i = 1, since for i = 0 calulated point is equal to start point
    for (int i = 1; i <= kSubdivisions; i++)
    {
        float t = i*step;
        
        float x = (1.0 - t)*(1.0 - t)*start.x + 2.0*(1.0 - t)*t*control.x + t*t*end.x;
        float y = (1.0 - t)*(1.0 - t)*start.y + 2.0*(1.0 - t)*t*control.y + t*t*end.y;
        
        CGPoint diff = CGPointMake(x - prevPoint.x, y - prevPoint.y);
        
        totalLength += sqrtf(diff.x*diff.x + diff.y*diff.y); // Pythagorean
        
        prevPoint = CGPointMake(x, y);
    }
    
    return totalLength;
}

-(void)cancelAnimation{
    //最关键是path路径
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //30度,经过反复测试，效果最好
    CGFloat angle = RaDians(30);
    
    CGFloat startPointX = self.center.x + raduis * cos(angle);
    CGFloat startPointY = kcenterY - raduis * sin(angle);
    
    CGFloat controlPointX = self.center.x + raduis *acos(angle);
    CGFloat controlPointY = kcenterY;
    
    CGFloat endPointX = self.center.x + lineWidth /2;
    CGFloat endPointY = kcenterY;
    
    //组合path 路径 起点 -150° 顺时针的圆
    path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x,kcenterY)
                                          radius:raduis
                                      startAngle:-M_PI + angle
                                        endAngle:M_PI + angle
                                       clockwise:YES];
    
    //起点为 180°-> (360°-30°)
    UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x,kcenterY
                                                                            
                                                                            )
                                                         radius:raduis
                                                     startAngle:M_PI + angle
                                                       endAngle:2 * M_PI - angle
                                                      clockwise:YES];
    [path appendPath:path1];
    
    //三点曲线
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    
    [path2 moveToPoint:CGPointMake(startPointX, startPointY)];
    
    [path2 addCurveToPoint:CGPointMake(endPointX,endPointY)
             controlPoint1:CGPointMake(startPointX, startPointY)
             controlPoint2:CGPointMake(controlPointX, controlPointY)];
    
    [path appendPath:path2];
    
    //比原始状态向左偏移5个像素
    UIBezierPath *path3 = [UIBezierPath bezierPath];
    [path3 moveToPoint:CGPointMake(endPointX,endPointY)];
    [path3 addLineToPoint:CGPointMake(self.center.x - lineWidth/2 -5,endPointY)];
    [path appendPath:path3];
    
    _changeLineLayer.path = path.CGPath;
    
    //平移量
    CGFloat toValue = lineWidth *(1- cos(M_PI_4)) /2.0;
    //finished 最终状态
    CGAffineTransform transform1 = CGAffineTransformMakeRotation(0);
    CGAffineTransform transform2 = CGAffineTransformMakeTranslation(0, 0);
    CGAffineTransform transform3 = CGAffineTransformMakeRotation(0);
    
    CGAffineTransform transform = CGAffineTransformConcat(transform1, transform2);
    _topLineLayer.affineTransform = transform;
    transform = CGAffineTransformConcat(transform3, transform2);
    _bottomLineLayer.affineTransform = transform;
    
    //一个圆的长度比
    CGFloat endPercent = 2* M_PI *raduis / ([self calculateTotalLength] + lineWidth);
    
    
    //横线占总path的长度比
    CGFloat percent = lineWidth / ([self calculateTotalLength] + lineWidth);
    
    _changeLineLayer.strokeStart = 1.0 -percent;
    
    CAKeyframeAnimation *startAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
    startAnimation.values = @[@0.0,@0.3,@(1.0 -percent)];
    
    //在π+ angle
    CAKeyframeAnimation *EndAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    EndAnimation.values = @[@(endPercent),@(endPercent),@1.0];
    
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:startAnimation,EndAnimation, nil];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.duration = Kstep4Dration;
    animationGroup.delegate = self;
    animationGroup.removedOnCompletion = YES;
 [_changeLineLayer setValue:@"animationStep4" forKey:@"animationName"];
    [_changeLineLayer addAnimation:animationGroup forKey:nil];
    
    //平移x
    CABasicAnimation *translationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    translationAnimation.fromValue = [NSNumber numberWithFloat:-toValue];
    translationAnimation.toValue = [NSNumber numberWithFloat:0];
    
    //角度关键帧 上横线的关键帧  (-45°) -> (-55°)-> 10° -> 0
    CAKeyframeAnimation *rotationAnimation1 = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation1.values = @[[NSNumber numberWithFloat:- M_PI_4 ],
                                  [NSNumber numberWithFloat:- RaDians(10) - M_PI_4 ],
                                  [NSNumber numberWithFloat:RaDians(10) ],
                                  [NSNumber numberWithFloat:0]
                                  ];
    
    
    CAAnimationGroup *transformGroup1 = [CAAnimationGroup animation];
    transformGroup1.animations = [NSArray arrayWithObjects:rotationAnimation1,translationAnimation, nil];
    transformGroup1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transformGroup1.duration = Kstep4Dration;
    transformGroup1.removedOnCompletion = YES;
    [_topLineLayer addAnimation:transformGroup1 forKey:nil];
    
    //角度关键帧 下横线的关键帧  (45°)-> (55°)- >（-10°）-> 0
    CAKeyframeAnimation *rotationAnimation2 = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation2.values = @[[NSNumber numberWithFloat: M_PI_4 ],
                                  [NSNumber numberWithFloat:RaDians(10) + M_PI_4 ],
                                  [NSNumber numberWithFloat:-RaDians(10) ],
                                  [NSNumber numberWithFloat:0]
                                  ];
    
    CAAnimationGroup *transformGroup2 = [CAAnimationGroup animation];
    transformGroup2.animations = [NSArray arrayWithObjects:rotationAnimation2,translationAnimation, nil];
    transformGroup2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transformGroup2.duration = Kstep4Dration;
    transformGroup2.delegate = self;
    transformGroup2.removedOnCompletion = YES;
    [_bottomLineLayer addAnimation:transformGroup2 forKey:nil];
    
}
@end
