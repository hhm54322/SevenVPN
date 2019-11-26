//
//  CircleView.m
//  Potatso
//
//  Created by 黄慧敏 on 2017/9/14.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "CircleView.h"
#import "CircleView+BaseConfiguration.h"

#define SELF_WIDTH CGRectGetWidth(self.bounds)
#define SELF_HEIGHT CGRectGetHeight(self.bounds)

@interface CircleView ()

@property (strong, nonatomic) CAShapeLayer *colorMaskLayer; // 渐变色遮罩
@property (strong, nonatomic) CAShapeLayer *colorLayer; // 渐变色
@property (strong, nonatomic) CAShapeLayer *blueMaskLayer; // 蓝色背景遮罩

@end

@implementation CircleView

+ (id)circleView
{
    CircleView* circleView = [[self alloc] init];
    return circleView;
}

- (void)setConnectStates:(NSInteger)states{
    _circleState = states;
    if(_circleState == DISCONNECT_STATE){
        self.persentage = 0;
    }else if(_circleState == CONNECT_STATE){
        self.persentage = 1;
    }
}

//当视图即将被加载到父试图上去的时候，系统会自动调用
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat selfW = newSuperview.frame.size.width * 0.8;
    CGFloat selfH = selfW;
    CGFloat selfX = (newSuperview.frame.size.width - selfW) / 2;
    CGFloat selfY = rectStatus.size.height * 4;
    self.frame = CGRectMake(selfX,selfY,selfW,selfH);
    self.backgroundColor = [CircleView backgroundColor];
    
    [self setupColorLayer];
    [self setupColorMaskLayer];
    [self setupBlueMaskLayer];
    
    [self addCenterLabel];
}

- (void)addCenterLabel{
    UILabel *m_centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    m_centerLabel.textAlignment = NSTextAlignmentCenter;
    m_centerLabel.textColor = [UIColor blackColor];
    m_centerLabel.adjustsFontSizeToFitWidth = YES;
    m_centerLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:18.0];
    m_centerLabel.numberOfLines = 0;
    
    m_centerLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    [m_centerLabel addGestureRecognizer:labelTapGestureRecognizer];
    
    [self addSubview:m_centerLabel];
}

-(void) labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    [_delegate btnClick:_circleState];
}

/**
 *  设置整个蓝色view的遮罩
 */
- (void)setupBlueMaskLayer {
    
    CAShapeLayer *layer = [self generateMaskLayer];
    self.layer.mask = layer;
    self.blueMaskLayer = layer;
}

/**
 *  设置渐变色，渐变色由左右两个部分组成，左边部分由黄到绿，右边部分由黄到红
 */
- (void)setupColorLayer {
    
    self.colorLayer = [CAShapeLayer layer];
    self.colorLayer.frame = self.bounds;
    [self.layer addSublayer:self.colorLayer];
    
    CAGradientLayer *leftLayer = [CAGradientLayer layer];
    leftLayer.frame = CGRectMake(0, 0, SELF_WIDTH, SELF_HEIGHT);
    // 分段设置渐变色
    leftLayer.locations = @[@0.3, @0.9, @1];
    leftLayer.colors = @[(id)[CircleView nbBlueColor].CGColor, (id)[CircleView lrBlueColor].CGColor];
    [self.colorLayer addSublayer:leftLayer];
    
    //    CAGradientLayer *rightLayer = [CAGradientLayer layer];
    //    rightLayer.frame = CGRectMake(SELF_WIDTH / 2, 0, SELF_WIDTH / 2, SELF_HEIGHT);
    //    rightLayer.locations = @[@0.3, @0.9, @1];
    //    rightLayer.colors = @[(id)[STLoopProgressView centerColor].CGColor, (id)[STLoopProgressView endColor].CGColor];
    //    [self.colorLayer addSublayer:rightLayer];
}

/**
 *  设置渐变色的遮罩
 */
- (void)setupColorMaskLayer {
    
    CAShapeLayer *layer = [self generateMaskLayer];
    layer.lineWidth = [CircleView lineWidth] + 0.5; // 渐变遮罩线宽较大，防止蓝色遮罩有边露出来
    self.colorLayer.mask = layer;
    self.colorMaskLayer = layer;
}

/**
 *  生成一个圆环形的遮罩层
 *  因为蓝色遮罩与渐变遮罩的配置都相同，所以封装出来
 *
 *  @return 环形遮罩
 */
- (CAShapeLayer *)generateMaskLayer {
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    
    // 创建一个圆心为父视图中点的圆，半径为父视图宽的2/5，起始角度是从-240°到60°
    
    UIBezierPath *path = nil;
    if ([CircleView clockWiseType]) {
        path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(SELF_WIDTH / 2, SELF_HEIGHT / 2) radius:SELF_WIDTH / 2.5 startAngle:[CircleView startAngle] endAngle:[CircleView endAngle] clockwise:YES];
    } else {
        path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(SELF_WIDTH / 2, SELF_HEIGHT / 2) radius:SELF_WIDTH / 2.5 startAngle:[CircleView endAngle] endAngle:[CircleView startAngle] clockwise:NO];
    }
    
    layer.lineWidth = [CircleView lineWidth];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor; // 填充色为透明（不设置为黑色）
    layer.strokeColor = [UIColor blackColor].CGColor; // 随便设置一个边框颜色
    layer.lineCap = kCALineCapRound; // 设置线为圆角
    return layer;
}

/**
 *  在修改百分比的时候，修改彩色遮罩的大小
 *
 *  @param persentage 百分比
 */
- (void)setPersentage:(CGFloat)persentage {
    
    _persentage = persentage;
    self.colorMaskLayer.strokeEnd = persentage;
}

@end
