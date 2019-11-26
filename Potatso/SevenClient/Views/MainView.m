//
//  MainView.m
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/5.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import "MainView.h"
#import "CircleView.h"

@interface MainView ()<CircleViewDelegate>

@end

@implementation MainView{
    UIImageView *shackImage;
    UIButton *connectBtn;
    UILabel *residualFlowLabel;
    UIImageView *countryIcon;
    UILabel *countryName;
    UILabel *addFlowLabel;
    float signFlow;
    BOOL m_isSign;
    NSTimer *m_timer;
    float m_value;
    BOOL m_isFadeIn;
    NSTimer *m_timer1;
    float m_value1;
    BOOL m_isFadeIn1;
    NSTimer *m_timer2;
    UIImageView *m_tipsImage;
    float m_value2;
    BOOL m_isFadeIn2;
    BOOL m_currentIsConnect;
    NSTimer *m_pingTimer;
    CircleView *m_circleView;
    UIImageView *m_connectCenterImage;
    UILabel *m_connectCenterLabel_1;
    UILabel *m_connectCenterLabel_2;
    UILabel *m_connectCenterLabel_3;
    UIImageView *m_connectCenterImage_4;
    UILabel *m_endTimeLabel;
    UILabel *m_signLabel;
    UIButton *m_buyBtn;
    UIImageView *m_arrowG;
    UILabel *m_newUserLabel;
    NSMutableArray *m_lineImageArray;
    NSMutableArray *m_dataLabelArray;
    UIImageView *m_dataImage;
    
    NSTimer *m_connectTimer;
    int m_totalTime;
    NSTimeInterval m_connectedTime;
    
    UIImageView *m_redPointImage;
}

+ (id)mainView
{
    MainView* mainView = [[self alloc] init];
    return mainView;
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
    //客服按钮
    UIButton *serviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selfX = 5;
    selfH = rectStatus.size.height * 1.5;
    selfW = selfH * 1.5;
    selfY = rectStatus.size.height;
    serviceBtn.frame = CGRectMake(selfX, selfY, selfW, selfH);
    [serviceBtn setBackgroundImage:[UIImage imageNamed:@"button_1_3"] forState:UIControlStateNormal];
    serviceBtn.tag = USERINFO_BTN_MAINVIEW;
    [serviceBtn addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:serviceBtn];
    
    //小红点
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    BOOL isShow = [userDefaultes boolForKey:@"redPoint_flow"];
    selfW = serviceBtn.frame.size.height * 0.3;
    selfH = selfW;
    selfX = serviceBtn.frame.origin.x + serviceBtn.frame.size.width * 0.45;
    selfY = serviceBtn.frame.origin.y + serviceBtn.frame.size.height * 0.12;
    m_redPointImage = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    m_redPointImage.image = [UIImage imageNamed:@"rp"];
    [self addSubview:m_redPointImage];
    m_redPointImage.hidden = isShow;
    
    
    //自动配置文本
    UILabel *labelLogo = [[UILabel alloc] init];
    selfX = self.frame.size.width / 4;
    selfW = self.frame.size.width / 2;
    selfY = rectStatus.size.height;
    selfH = rectStatus.size.height * 1.5;
    labelLogo.frame = CGRectMake(selfX, selfY, selfW, selfH);
    labelLogo.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:18.0];
    labelLogo.text = @"泡泡加速器";
    labelLogo.textAlignment = NSTextAlignmentCenter;
    labelLogo.textColor = [UIColor whiteColor];
    [self addSubview:labelLogo];
}

- (void)addDownTabbar{
    CGFloat selfX = 0;
    CGFloat selfW = self.frame.size.width;
    CGFloat selfH = self.frame.size.width * 0.15;
    CGFloat selfY = self.frame.size.height - selfH;
    //购买套餐按钮
    m_buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    m_buyBtn.frame = CGRectMake(selfX, selfY, selfW, selfH);
    [m_buyBtn setBackgroundImage:[UIImage imageNamed:@"frame_3"] forState:UIControlStateNormal];
    m_buyBtn.tag = BUY_BTN_MAINVIEW;
    [m_buyBtn addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:m_buyBtn];
    
    //图标
    selfH = m_buyBtn.frame.size.height * 0.5;
    selfW = selfH;
    selfX = m_buyBtn.frame.size.height * 0.3;
    selfY = (m_buyBtn.frame.size.height - selfH) / 2;
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    iconImage.image = [UIImage imageNamed:@"icon02"];
    [m_buyBtn addSubview:iconImage];
    
    //会员中心文本
    selfW = m_buyBtn.frame.size.width * 0.25;
    selfH = m_buyBtn.frame.size.height * 0.3;
    selfX = iconImage.frame.origin.x + iconImage.frame.size.width + 5;
    selfY = iconImage.frame.origin.y;
    UILabel *centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    centerLabel.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:14.0];
    centerLabel.textColor = [UIColor whiteColor];
    centerLabel.textAlignment = NSTextAlignmentLeft;
    centerLabel.adjustsFontSizeToFitWidth = YES;
    centerLabel.text = @"会员中心";
    [m_buyBtn addSubview:centerLabel];
    //会员中心描述文本
    selfW = m_buyBtn.frame.size.width * 0.3;
    selfH = m_buyBtn.frame.size.height * 0.3;
    selfX = iconImage.frame.origin.x + iconImage.frame.size.width + 5;
    selfY = m_buyBtn.frame.size.height / 2;
    UILabel *centerDesLabel = [[UILabel alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    centerDesLabel.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:12.0];
    centerDesLabel.textColor = [UIColor colorWithRed:160/255.0 green:180/255.0 blue:205/255.0 alpha:1];
    centerDesLabel.textAlignment = NSTextAlignmentLeft;
    centerDesLabel.adjustsFontSizeToFitWidth = YES;
    centerDesLabel.text = @"极速体验，优惠享不停";
    [m_buyBtn addSubview:centerDesLabel];
    
    //跳转箭头
    selfH = m_buyBtn.frame.size.height * 0.25;
    selfW = selfH * 0.6;
    selfX = m_buyBtn.frame.size.width - m_buyBtn.frame.size.height * 0.4;
    selfY = (m_buyBtn.frame.size.height - selfH) / 2;
    m_arrowG = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    m_arrowG.image = [UIImage imageNamed:@"arrowG"];
    [m_buyBtn addSubview:m_arrowG];
    
    //新手福利文本
    selfH = m_buyBtn.frame.size.height * 0.34;
    selfW = m_buyBtn.frame.size.width * 0.34;
    selfX = m_buyBtn.frame.size.width - selfW - m_buyBtn.frame.size.height * 0.55;
    selfY = (m_buyBtn.frame.size.height - selfH) / 2;
    m_newUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    m_newUserLabel.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:14.0];
    m_newUserLabel.textColor = [UIColor colorWithRed:60/255.0 green:90/255.0 blue:150/255.0 alpha:1];
    m_newUserLabel.textAlignment = NSTextAlignmentRight;
    m_newUserLabel.adjustsFontSizeToFitWidth = YES;
    m_newUserLabel.text = @"获取新人优享福利";
    [m_buyBtn addSubview:m_newUserLabel];
}

- (void)addConnectBall{
    m_circleView = [CircleView circleView];
    m_circleView.delegate = self;
    [self addSubview:m_circleView];
    
    float selfW = m_circleView.frame.size.width * 0.41;
    float selfH = selfW * 0.35;
    float selfX = (self.frame.size.width - selfW) / 2;
    float selfY = m_circleView.frame.origin.y + (m_circleView.frame.size.height - selfH) / 2;
    m_connectCenterImage = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    m_connectCenterImage.image = [UIImage imageNamed:@"button_1_10"];
    [self addSubview:m_connectCenterImage];
    m_connectCenterImage.hidden = YES;
    
    selfW = m_circleView.frame.size.width * 0.8;
    selfH = m_circleView.frame.size.height * 0.4;
    selfX = m_circleView.frame.origin.x + m_circleView.frame.size.width * 0.1;
    selfY = m_circleView.frame.origin.y + (m_circleView.frame.size.height - selfH) * 0.3;
    m_connectCenterLabel_1 = [[UILabel alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    m_connectCenterLabel_1.textAlignment = NSTextAlignmentCenter;
    m_connectCenterLabel_1.textColor = [UIColor colorWithRed:60/255.0 green:90/255.0 blue:150/255.0 alpha:1];
    m_connectCenterLabel_1.adjustsFontSizeToFitWidth = YES;
    m_connectCenterLabel_1.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:40.0];
    [self addSubview:m_connectCenterLabel_1];
    m_connectCenterLabel_1.hidden = YES;
    
    selfW = m_circleView.frame.size.width * 0.8;
    selfH = m_circleView.frame.size.height * 0.2;
    selfX = m_circleView.frame.origin.x + m_circleView.frame.size.width * 0.1;
    selfY = m_circleView.frame.origin.y + (m_circleView.frame.size.height - selfH) * 0.52;
    m_connectCenterLabel_2 = [[UILabel alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    m_connectCenterLabel_2.textAlignment = NSTextAlignmentCenter;
    m_connectCenterLabel_2.textColor = [UIColor whiteColor];
    m_connectCenterLabel_2.adjustsFontSizeToFitWidth = YES;
    m_connectCenterLabel_2.text = @"加速中";
    m_connectCenterLabel_2.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:24.0];
    [self addSubview:m_connectCenterLabel_2];
    m_connectCenterLabel_2.hidden = YES;
    
    selfW = m_circleView.frame.size.width * 0.8;
    selfH = m_circleView.frame.size.height * 0.3;
    selfX = m_circleView.frame.origin.x + m_circleView.frame.size.width * 0.1;
    selfY = m_circleView.frame.origin.y + (m_circleView.frame.size.height - selfH) * 0.4;
    m_connectCenterLabel_3 = [[UILabel alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    m_connectCenterLabel_3.textAlignment = NSTextAlignmentCenter;
    m_connectCenterLabel_3.textColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
    m_connectCenterLabel_3.adjustsFontSizeToFitWidth = YES;
    m_connectCenterLabel_3.text = @"00:00:00";
    m_connectCenterLabel_3.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:32.0];
    [self addSubview:m_connectCenterLabel_3];
    m_connectCenterLabel_3.hidden = YES;
    
    selfW = m_circleView.frame.size.width * 0.41;
    selfH = selfW * 0.35;
    selfX = (self.frame.size.width - selfW) / 2;
    selfY = m_circleView.frame.origin.y + m_circleView.frame.size.height * 0.52;
    m_connectCenterImage_4 = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    m_connectCenterImage_4.image = [UIImage imageNamed:@"button_1_11"];
    [self addSubview:m_connectCenterImage_4];
    m_connectCenterImage_4.hidden = YES;
}

- (void)setConnectStates:(NSInteger)states{
    [m_circleView setConnectStates:states];
    [self setConnectLabel];
}

- (NSInteger)getConnectStates{
    return m_circleView.circleState;
}

- (void)setConnectLabel{
    if(m_circleView.circleState == DISCONNECT_STATE){
        m_connectCenterImage.hidden = NO;
        m_connectCenterLabel_1.hidden = YES;
        m_connectCenterLabel_2.hidden = YES;
        m_connectCenterLabel_3.hidden = YES;
        m_connectCenterImage_4.hidden = YES;
    }else if(m_circleView.circleState == CONNECTING_STATE){
        
    }else if(m_circleView.circleState == CONNECT_STATE){
        m_connectCenterImage.hidden = YES;
        m_connectCenterLabel_1.hidden = YES;
        m_connectCenterLabel_2.hidden = YES;
        m_connectCenterLabel_3.hidden = NO;
        m_connectCenterImage_4.hidden = NO;
    }
}

- (void)btnClick:(NSInteger)type{
    if(type == DISCONNECT_STATE || type == CONNECT_STATE){
        _circleState = type;
        [_delegate mainView:self andDidSelectedItem:nil andSelectedIndex:CONNECT_BTN_MAINVIEW];
        if(type == CONNECT_STATE){
            [self updateServiceState:NO];
        }
    }
}

- (void)connectFun{
    if(_circleState == DISCONNECT_STATE){
        m_circleView.circleState = CONNECTING_STATE;
        m_connectCenterImage.hidden = YES;
        m_connectCenterLabel_1.hidden = NO;
        m_connectCenterLabel_2.hidden = NO;
        m_connectCenterLabel_3.hidden = YES;
        m_connectCenterImage_4.hidden = YES;
        [self startConnectAnimation];
    }else if(_circleState == CONNECTING_STATE){

    }else if(_circleState == CONNECT_STATE){
        [self setConnectStates:DISCONNECT_STATE];
    }
}

- (void)startConnectAnimation{
    m_value = 0;
    if(m_timer == nil){
        m_timer = [NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(animationFun) userInfo:nil repeats:YES];
    }
}
- (void)stopAnimation{
    if(m_timer){
        [m_timer invalidate];
        m_timer = nil;
    }
}

- (void)animationFun{
    m_value += 0.01;
    m_circleView.persentage = m_value;
    if(m_value >= 1){
        m_circleView.persentage = 1;
        [self stopAnimation];
        [self updateServiceState:YES];
        m_circleView.circleState = CONNECT_STATE;
        [self setConnectLabel];
    }else{
        int value = m_value * 100;
        m_connectCenterLabel_1.text = [[NSString alloc] initWithFormat:@"%d%@",value,@"%"];
    }
}

-(NSString*)getCurrentTime:(NSInteger)utfTime{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval newTime = [dat timeIntervalSince1970];
    if(newTime >= utfTime){
        return @"会员已到期，点击下方会员中心开通会员";
    }else{
        int value = utfTime - newTime;
        if(value / 86400 > 0){
            return [NSString stringWithFormat:@"您的会员到期时间还有 %d 天",value / 86400];
        }
        return @"您的会员到期时间 < 1天";
    }
    return @"";
}

- (void)setEndTimeFun:(NSInteger)times{
    m_endTimeLabel.text = [self getCurrentTime:times];
}

- (void)setFlowLabelFun:(float)flowValue{
    if(flowValue > 0){
        m_endTimeLabel.text = [NSString stringWithFormat:@"您的剩余流量 %.1f MB",flowValue];
    }else{
        m_endTimeLabel.text = @"流量已用尽，点击下方会员中心开通会员";
    }
}

- (void)setSignLabel{
    int times = signFlow / 60;
    if(m_isSign){
        m_signLabel.textColor = [UIColor blueColor];
        m_signLabel.text = [[NSString alloc] initWithFormat:@"\n%d分钟  领取成功",times];
    }else{
        m_signLabel.textColor = [UIColor greenColor];
        m_signLabel.text = [[NSString alloc] initWithFormat:@"\n%d分钟  点击领取",times];
    }
}

- (void)updateSignFlow:(float)value{
    signFlow = value;
    [self setSignLabel];
}

- (void)updateSignState:(BOOL)isSign{
    m_isSign = isSign;
    [self setSignLabel];
}

- (void)addCenterTabbar{
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    //网路延迟图标
    CGFloat selfW = self.frame.size.width * 0.22;
    CGFloat selfH = selfW * 0.185;
    CGFloat selfX = m_circleView.frame.origin.x;
    CGFloat selfY = m_circleView.frame.origin.y + m_circleView.frame.size.height + rectStatus.size.height * 1.5;
    UIImageView *lagImage = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    lagImage.image = [UIImage imageNamed:@"title3"];
    [self addSubview:lagImage];
    
    //综合提速图标
    selfW = self.frame.size.width * 0.22;
    selfH = selfW * 0.185;
    selfX = (self.frame.size.width - selfW) / 2;
    selfY = m_circleView.frame.origin.y + m_circleView.frame.size.height + rectStatus.size.height * 1.5;
    UIImageView *tisuImage = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    tisuImage.image = [UIImage imageNamed:@"title2"];
    [self addSubview:tisuImage];
    
    //丢包率图标
    selfW = self.frame.size.width * 0.22;
    selfH = selfW * 0.185;
    selfX = self.frame.size.width - selfW - m_circleView.frame.origin.x;
    selfY = m_circleView.frame.origin.y + m_circleView.frame.size.height + rectStatus.size.height * 1.5;
    UIImageView *lossImage = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    lossImage.image = [UIImage imageNamed:@"title1"];
    [self addSubview:lossImage];
    
    //未连接状态横线
    m_lineImageArray = [[NSMutableArray alloc] init];
    selfW = lagImage.frame.size.width * 0.5;
    selfH = selfW;
    selfX = lagImage.frame.origin.x + lagImage.frame.size.width * 0.25;
    selfY = lagImage.frame.origin.y + lagImage.frame.size.height;
    UIImageView *lineImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    lineImage1.image = [UIImage imageNamed:@"iconC6"];
    [self addSubview:lineImage1];
    [m_lineImageArray addObject:lineImage1];
    
    selfW = tisuImage.frame.size.width * 0.5;
    selfH = selfW;
    selfX = (self.frame.size.width - selfW) / 2;
    selfY = tisuImage.frame.origin.y + tisuImage.frame.size.height;
    UIImageView *lineImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    lineImage2.image = [UIImage imageNamed:@"iconC6"];
    [self addSubview:lineImage2];
    [m_lineImageArray addObject:lineImage2];
    
    selfW = lossImage.frame.size.width * 0.5;
    selfH = selfW;
    selfX = lossImage.frame.origin.x + lossImage.frame.size.width * 0.25;
    selfY = lossImage.frame.origin.y + lossImage.frame.size.height;
    UIImageView *lineImage3 = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    lineImage3.image = [UIImage imageNamed:@"iconC6"];
    [self addSubview:lineImage3];
    [m_lineImageArray addObject:lineImage3];
    
    //底部单位图标
    selfW = lagImage.frame.size.width * 0.2;
    selfH = selfW;
    selfX = lagImage.frame.origin.x + lagImage.frame.size.width * 0.4;
    selfY = lineImage1.frame.origin.y + lineImage1.frame.size.height;
    UIImageView *unitImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    unitImage1.image = [UIImage imageNamed:@"title4"];
    [self addSubview:unitImage1];
    
    selfX = (self.frame.size.width - selfW) / 2;
    UIImageView *unitImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    unitImage2.image = [UIImage imageNamed:@"title5"];
    [self addSubview:unitImage2];
    
    selfX = lossImage.frame.origin.x + lossImage.frame.size.width * 0.4;
    UIImageView *unitImage3 = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    unitImage3.image = [UIImage imageNamed:@"title5"];
    [self addSubview:unitImage3];
    
    m_dataLabelArray = [[NSMutableArray alloc] init];
    selfW = lagImage.frame.size.width * 0.5;
    selfH = selfW;
    selfX = lagImage.frame.origin.x + lagImage.frame.size.width * 0.25;
    selfY = lagImage.frame.origin.y + lagImage.frame.size.height;
    UILabel *dataLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    dataLabel1.textAlignment = NSTextAlignmentCenter;
    dataLabel1.textColor = [UIColor colorWithRed:60/255.0 green:90/255.0 blue:150/255.0 alpha:1];
    dataLabel1.adjustsFontSizeToFitWidth = YES;
    dataLabel1.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:26.0];
    dataLabel1.text = @"94";
    [self addSubview:dataLabel1];
    [m_dataLabelArray addObject:dataLabel1];
    dataLabel1.hidden = YES;
    
    selfW = tisuImage.frame.size.width * 0.5;
    selfH = selfW;
    selfX = (self.frame.size.width - selfW) / 2;
    selfY = tisuImage.frame.origin.y + tisuImage.frame.size.height;
    UILabel *dataLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    dataLabel2.textAlignment = NSTextAlignmentCenter;
    dataLabel2.textColor = [UIColor colorWithRed:60/255.0 green:90/255.0 blue:150/255.0 alpha:1];
    dataLabel2.adjustsFontSizeToFitWidth = YES;
    dataLabel2.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:26.0];
    dataLabel2.text = @"90";
    [self addSubview:dataLabel2];
    [m_dataLabelArray addObject:dataLabel2];
    dataLabel2.hidden = YES;
    
    selfW = lossImage.frame.size.width * 0.5;
    selfH = selfW;
    selfX = lossImage.frame.origin.x + lossImage.frame.size.width * 0.25;
    selfY = lossImage.frame.origin.y + lossImage.frame.size.height;
    UILabel *dataLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    dataLabel3.textAlignment = NSTextAlignmentCenter;
    dataLabel3.textColor = [UIColor colorWithRed:60/255.0 green:90/255.0 blue:150/255.0 alpha:1];
    dataLabel3.adjustsFontSizeToFitWidth = YES;
    dataLabel3.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:26.0];
    dataLabel3.text = @"0";
    [self addSubview:dataLabel3];
    [m_dataLabelArray addObject:dataLabel3];
    dataLabel3.hidden = YES;
    
    selfH = lineImage2.frame.size.width * 0.5;
    selfW = selfH * 0.45;
    selfX = lineImage2.frame.origin.x + lineImage2.frame.size.width;
    selfY = tisuImage.frame.origin.y + tisuImage.frame.size.height + selfH * 0.5;
    m_dataImage = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    m_dataImage.image = [UIImage imageNamed:@"uparrow"];
    [self addSubview:m_dataImage];
    m_dataImage.hidden = YES;
    
    
    //左侧到期时间文本
    selfW = self.frame.size.width * 0.8;
    selfH = self.frame.size.height * 0.125;
    selfX = self.frame.size.width * 0.1;
    selfY = self.frame.size.height * 0.83;
    m_endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    m_endTimeLabel.textAlignment = NSTextAlignmentCenter;
    m_endTimeLabel.textColor = [UIColor lightGrayColor];
    m_endTimeLabel.adjustsFontSizeToFitWidth = YES;
    m_endTimeLabel.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:16.0];
    m_endTimeLabel.numberOfLines = 0;
    [self addSubview:m_endTimeLabel];
}

-(void) labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    if(!m_isSign){
        [_delegate mainView:self andDidSelectedItem:nil andSelectedIndex:SIGN_BTN_MAINVIEW];
    }
}


- (void)addConnectImage{
    m_tipsImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tips"]];
    [m_tipsImage setFrame:CGRectMake((self.frame.size.width - m_tipsImage.frame.size.width / 2) / 2, self.frame.size.height / 4, m_tipsImage.frame.size.width / 2, m_tipsImage.frame.size.height / 2)];
    m_tipsImage.alpha = 0;
    [self addSubview:m_tipsImage];
}

- (void)btnTouch:(UIButton*)btn
{
    [_delegate mainView:self andDidSelectedItem:btn andSelectedIndex:(short)btn.tag];
}

- (void)setRedPointVisible{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    BOOL isShow = [userDefaultes boolForKey:@"redPoint_flow"];
    m_redPointImage.hidden = isShow;
}

- (void)updateServiceState:(BOOL)isService{
    if(isService){
        [connectBtn setBackgroundImage:[UIImage imageNamed:@"round_2"] forState:UIControlStateNormal];
        [m_tipsImage setImage:[UIImage imageNamed:@"tips"]];
        [shackImage setHidden:NO];
    }else{
        [connectBtn setBackgroundImage:[UIImage imageNamed:@"round_1"] forState:UIControlStateNormal];
        [m_tipsImage setImage:[UIImage imageNamed:@"tips2"]];
        [shackImage setHidden:YES];
    }
    if(m_currentIsConnect != isService){
        [self startAnimationByConnectImage];
        if(isService){
            [self startPing];
            [self startConnectTimer];
        }
    }
    m_currentIsConnect = isService;
}

- (void)showAddFlowLabel:(float)value{
    int times = value / 60;
    addFlowLabel.text = [NSString stringWithFormat:@"+%d分钟",times];
    [self startAnimationByAddFlowLabel];
}

- (void)startAnimationByAddFlowLabel{
    m_value1 = 0;
    m_isFadeIn1 = YES;
    if(m_timer1 == nil){
        m_timer1 = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(animationByAddFlowLabelFun) userInfo:nil repeats:YES];
    }else{
        [m_timer1 setFireDate:[NSDate distantPast]];
    }
}
- (void)stopAnimationByAddFlowLabel{
    if(m_timer1){
        [m_timer1 setFireDate:[NSDate distantFuture]];
    }
}

- (void)animationByAddFlowLabelFun{
    addFlowLabel.alpha = m_value1;
    if(m_isFadeIn1){
        m_value1 += 0.02;
        if(m_value1 >= 1){
            m_isFadeIn1 = NO;
        }
    }else{
        m_value1 -= 0.02;
        if(m_value1 <= 0){
            [self stopAnimationByAddFlowLabel];
        }
    }
}

- (void)startAnimationByConnectImage{
    m_value2 = 0;
    m_isFadeIn2 = YES;
    if(m_timer2 == nil){
        m_timer2 = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(animationByConnectImageFun) userInfo:nil repeats:YES];
    }else{
        [m_timer2 setFireDate:[NSDate distantPast]];
    }
}
- (void)stopAnimationByConnectImage{
    if(m_timer2){
        [m_timer2 setFireDate:[NSDate distantFuture]];
    }
}

- (void)animationByConnectImageFun{
    m_tipsImage.alpha = m_value2;
    if(m_isFadeIn2){
        m_value2 += 0.02;
        if(m_value2 >= 1){
            m_isFadeIn2 = NO;
        }
    }else{
        m_value2 -= 0.02;
        if(m_value2 <= 0){
            [self stopAnimationByAddFlowLabel];
        }
    }
}

- (void)startPing{
    for(int i = 0;i<m_lineImageArray.count;i++){
        UIImageView *lineImage = [m_lineImageArray objectAtIndex:i];
        lineImage.hidden = YES;
        UILabel *dataLabel = [m_dataLabelArray objectAtIndex:i];
        dataLabel.hidden = NO;
        m_dataImage.hidden = NO;
    }
    [self showPingData];
    if(m_pingTimer == nil){
        m_pingTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(showPingData) userInfo:nil repeats:YES];
    }else{
        [m_pingTimer setFireDate:[NSDate distantPast]];
    }
}

- (void)stopPing{
    if(m_pingTimer){
        [m_pingTimer setFireDate:[NSDate distantFuture]];
    }
    for(int i = 0;i<m_lineImageArray.count;i++){
        UIImageView *lineImage = [m_lineImageArray objectAtIndex:i];
        lineImage.hidden = NO;
        UILabel *dataLabel = [m_dataLabelArray objectAtIndex:i];
        dataLabel.hidden = YES;
        m_dataImage.hidden = YES;
    }
}

- (void)clearPingTimer{
    if(m_pingTimer){
        [m_pingTimer invalidate];
        m_pingTimer = nil;
    }
}

- (void)showPingData{
    int pingTotal = 30 + arc4random() % 21;
    int tisuNum = 90 + arc4random() % 9;
    UILabel *pingLabel = [m_dataLabelArray objectAtIndex:0];
    pingLabel.text = [NSString stringWithFormat:@"%d",pingTotal];
    UILabel *tisuLabel = [m_dataLabelArray objectAtIndex:1];
    tisuLabel.text = [NSString stringWithFormat:@"%d",tisuNum];
    UILabel *lossLabel = [m_dataLabelArray objectAtIndex:2];
    lossLabel.text = @"0";
}

- (void)startConnectTimer{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    m_connectedTime = [dat timeIntervalSince1970];
    m_totalTime = 0;
    m_connectCenterLabel_3.text = @"00:00:00";
    if(m_connectTimer == nil){
        m_connectTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showConnectTimeFun) userInfo:nil repeats:YES];
    }else{
        [m_connectTimer setFireDate:[NSDate distantPast]];
    }
}

- (void)stopConnectTimer{
    if(m_connectTimer){
        [m_connectTimer setFireDate:[NSDate distantFuture]];
    }
}

- (void)showConnectTimeFun{
    m_totalTime++;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval nowTime = [dat timeIntervalSince1970];
    if(m_connectedTime + m_totalTime < nowTime - 5){
        m_totalTime = nowTime - m_connectedTime;
    }
    int seconds = m_totalTime % 60;
    int minutes = (m_totalTime / 60) % 60;
    int hours = m_totalTime / 3600;
    m_connectCenterLabel_3.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

- (void)clearConnectTimer{
    if(m_connectTimer){
        [m_connectTimer invalidate];
        m_pingTimer = nil;
    }
}

- (void)updateNewUserInfo:(BOOL)value{
    m_newUserLabel.hidden = value;
    m_arrowG.image = [UIImage imageNamed:value ? @"arrowW" : @"arrowG"];
}

//当视图即将被加载到父试图上去的时候，系统会自动调用
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    self.frame = newSuperview.frame;
    
    //添加背景图片1
    UIImageView *backGround1 = [[UIImageView alloc] initWithFrame:self.frame];
    backGround1.image = [UIImage imageNamed:@"background_cloud2"];
    [self addSubview:backGround1];
    
    //添加顶部菜单栏
    [self addTopTabbar];
    //添加底部菜单栏
    [self addDownTabbar];
    //添加连接球
    [self addConnectBall];
    [self setConnectStates:DISCONNECT_STATE];
    //添加中部菜单栏
    [self addCenterTabbar];
    //添加连接成功和断开连接图片
    [self addConnectImage];
    
}

- (void)dealloc{
    [self stopAnimation];
    [self stopAnimationByAddFlowLabel];
    [self stopAnimationByConnectImage];
    [self clearPingTimer];
    [self clearConnectTimer];
    NSLog(@"MainView被销毁");
}

@end
