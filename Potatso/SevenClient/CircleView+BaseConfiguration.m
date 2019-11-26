//
//  CircleView+BaseConfiguration.m
//  Potatso
//
//  Created by 黄慧敏 on 2017/9/15.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "CircleView+BaseConfiguration.h"

#define DEGREES_TO_RADOANS(x) (M_PI * (x) / 180.0) // 将角度转为弧度

@implementation CircleView (BaseConfiguration)

+ (UIColor *)startColor {
    
    return [UIColor greenColor];
}

+ (UIColor *)centerColor {
    
    return [UIColor yellowColor];
}

+ (UIColor *)endColor {
    
    return [UIColor redColor];
}

+ (UIColor *)backgroundColor {
    
    return [UIColor colorWithRed:38.0 / 255.0 green:47.0 / 255.0 blue:56.0 / 255.0 alpha:1];
}

+ (UIColor *)lrBlueColor {
    
    return [UIColor colorWithRed:60.0 / 255.0 green:90.0 / 255.0 blue:150.0 / 255.0 alpha:1];
}

+ (UIColor *)nbBlueColor {
    
    return [UIColor colorWithRed:60.0 / 255.0 green:100.0 / 255.0 blue:150.0 / 255.0 alpha:1];
}




+ (CGFloat)lineWidth {
    
    return 10;
}

+ (CGFloat)startAngle {
    
    return DEGREES_TO_RADOANS(-360);
}

+ (CGFloat)endAngle {
    
    return DEGREES_TO_RADOANS(0);
}

+ (STClockWiseType)clockWiseType {
    return STClockWiseNo;
}


@end
