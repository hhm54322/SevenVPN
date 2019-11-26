//
//  BuySaveView.m
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/21.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import "BuySaveView.h"
#import "BuySaveData.h"

@implementation BuySaveView

+ (id)buySaveView
{
    BuySaveView *buySaveView = [[BuySaveView alloc] init];
    return buySaveView;
}

- (void)btnTouch:(UIButton*)btn
{
    [_delegate backClick];
}

- (void)addTopTabbar{
    // 状态栏(statusbar)
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat selfX = 0;
    CGFloat selfW = self.frame.size.width;
    CGFloat selfH = rectStatus.size.height * 2.5;
    CGFloat selfY = 0;
    //添加背景图
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    background.image = [UIImage imageNamed:@"frame_0"];
    [self addSubview:background];
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selfX = 0;
    selfH = rectStatus.size.height * 1.5;
    selfW = selfH * 1.5;
    selfY = rectStatus.size.height;
    backBtn.frame = CGRectMake(selfX, selfY, selfW, selfH);
    UIImage *arrowImage = [UIImage imageNamed:@"backArrow"];
    [backBtn setBackgroundImage:arrowImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    
    //购买记录文本
    UILabel *labelLogo = [[UILabel alloc] init];
    selfX = self.frame.size.width / 3;
    selfW = self.frame.size.width / 3;
    labelLogo.frame = CGRectMake(selfX, selfY, selfW, selfH);
    labelLogo.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:18.0];
    labelLogo.text = @"购买记录";
    labelLogo.textAlignment = NSTextAlignmentCenter;
    labelLogo.textColor = [UIColor whiteColor];
    [self addSubview:labelLogo];
    
    //说明文本底图
    selfX = 0;
    selfY = rectStatus.size.height * 2.5;
    selfW = self.frame.size.width;
    selfH = rectStatus.size.height * 2.5;
    UIImageView *imageDes = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    imageDes.backgroundColor = [UIColor colorWithRed:11/255.0 green:18/255.0 blue:22/255.0 alpha:1];
    [self addSubview:imageDes];
    
    //说明文本
    UILabel *labelDes = [[UILabel alloc] init];
    labelDes.frame = CGRectMake(selfX, selfY, selfW, selfH);
    labelDes.adjustsFontSizeToFitWidth = YES;
    labelDes.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:18.0];
    labelDes.text = @"显示最近的三次购买记录";
    labelDes.textAlignment = NSTextAlignmentCenter;
    labelDes.textColor = [UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1];
    [self addSubview:labelDes];
}

- (void)setItemList:(NSMutableArray *)buySaveDataArray{
    if(buySaveDataArray == nil) return;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    for(int i = 0;i < buySaveDataArray.count;i++){
        BuySaveData *data = buySaveDataArray[i];
        //加载背景图片
        CGFloat selfW = self.frame.size.width - self.frame.size.width / 10;
        CGFloat selfH = (self.frame.size.height - rectStatus.size.height * 6) / 4;
        CGFloat selfX = (self.frame.size.width - selfW) / 2;
        CGFloat selfY = rectStatus.size.height * 6 + (selfH / 4) * (i + 1) + selfH * i;
        UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
        background.image = [UIImage imageNamed:@"frame_4"];
        [self addSubview:background];
        //订单号
        selfW = background.frame.size.width;
        selfH = background.frame.size.height / 100 * 27;
        selfX = 0;
        selfY = 0;
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
        [background addSubview:topView];
        selfW = topView.frame.size.width / 4;
        selfH = topView.frame.size.height;
        UILabel *orderIdDes = [[UILabel alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
        orderIdDes.textAlignment = NSTextAlignmentCenter;
        orderIdDes.textColor = [UIColor grayColor];
        orderIdDes.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:18.0];
        orderIdDes.text = @"订单号";
        [topView addSubview:orderIdDes];
        selfW = topView.frame.size.width - topView.frame.size.width / 3;
        selfX = topView.frame.size.width / 3;
        UILabel *orderIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
        orderIdLabel.textAlignment = NSTextAlignmentLeft;
        orderIdLabel.textColor = [UIColor grayColor];
        orderIdLabel.adjustsFontSizeToFitWidth = YES;
        orderIdLabel.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:18.0];
        orderIdLabel.text = data.orderId;
        [topView addSubview:orderIdLabel];
        //订单信息
        selfW = background.frame.size.width;
        selfH = background.frame.size.height - topView.frame.size.height - background.frame.size.height / 50;
        selfX = 0;
        selfY = topView.frame.size.height + background.frame.size.height / 100;
        UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
        [background addSubview:downView];
        selfW = downView.frame.size.width / 100 * 29;
        selfH = downView.frame.size.height / 3;
        selfX = 0;
        selfY = 0;
        UILabel *orderNameDes = [[UILabel alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
        orderNameDes.textAlignment = NSTextAlignmentCenter;
        orderNameDes.textColor = [UIColor grayColor];
        orderNameDes.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:16.0];
        orderNameDes.text = @"订单名称：";
        [downView addSubview:orderNameDes];
        selfW = downView.frame.size.width - orderNameDes.frame.size.width;
        selfX = orderNameDes.frame.size.width;
        UILabel *orderNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
        orderNameLabel.textAlignment = NSTextAlignmentLeft;
        orderNameLabel.textColor = [UIColor grayColor];
        orderNameLabel.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:16.0];
        orderNameLabel.text = data.orderName;
        [downView addSubview:orderNameLabel];
        
        selfW = downView.frame.size.width / 100 * 29;
        selfH = downView.frame.size.height / 3;
        selfX = 0;
        selfY = downView.frame.size.height / 3;
        UILabel *orderPriceDes = [[UILabel alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
        orderPriceDes.textAlignment = NSTextAlignmentCenter;
        orderPriceDes.textColor = [UIColor grayColor];
        orderPriceDes.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:16.0];
        orderPriceDes.text = @"订单价格：";
        [downView addSubview:orderPriceDes];
        selfW = downView.frame.size.width - orderPriceDes.frame.size.width;
        selfX = orderPriceDes.frame.size.width;
        UILabel *orderPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
        orderPriceLabel.textAlignment = NSTextAlignmentLeft;
        orderPriceLabel.textColor = [UIColor grayColor];
        orderPriceLabel.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:16.0];
        orderPriceLabel.text = [NSString stringWithFormat:@"%@%.2f",@"￥",data.price];
        [downView addSubview:orderPriceLabel];
        
        selfW = downView.frame.size.width / 100 * 29;
        selfH = downView.frame.size.height / 3;
        selfX = 0;
        selfY = downView.frame.size.height / 3 * 2;
        UILabel *orderTimeDes = [[UILabel alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
        orderTimeDes.textAlignment = NSTextAlignmentCenter;
        orderTimeDes.textColor = [UIColor grayColor];
        orderTimeDes.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:16.0];
        orderTimeDes.text = @"购买时间：";
        [downView addSubview:orderTimeDes];
        //selfW = (downView.frame.size.width - orderTimeDes.frame.size.width) / 2;
        selfW = downView.frame.size.width - orderTimeDes.frame.size.width;
        selfX = orderTimeDes.frame.size.width;
        UILabel *orderTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
        orderTimeLabel.textAlignment = NSTextAlignmentLeft;
        orderTimeLabel.textColor = [UIColor grayColor];
        orderTimeLabel.adjustsFontSizeToFitWidth = YES;
        orderTimeLabel.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:16.0];
        orderTimeLabel.text = data.orderTime;
        [downView addSubview:orderTimeLabel];
    }
}

//时间戳转化成字符串格式日期 YYYY-MM-dd
- (NSString*)dateTimeFromTimespEx:(NSString*)timeStamp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue] / 1000];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *confromTimespStr_1 = [formatter stringFromDate:confromTimesp];
    NSLog(@"%@",confromTimespStr_1);
    return confromTimespStr;
}

//时间戳转化成字符串格式日期 HH-mm-ss
- (NSString*)dateTimeFromTimespEx_1:(NSString*)timeStamp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue] / 1000];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

//当视图即将被加载到父试图上去的时候，系统会自动调用
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    self.frame = newSuperview.frame;
    self.backgroundColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1];
    //添加顶部菜单栏
    [self addTopTabbar];
    
}

- (void)dealloc{
    NSLog(@"BuySaveView被销毁");
}

@end
