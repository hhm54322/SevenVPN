//
//  MainController.m
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/5.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import "MainController.h"
#import "MainView.h"
#import "HttpUtils.h"
#import "UserInfo.h"
#import "IndicatorView.h"
#import "UserInfoController.h"
#import "AreaController.h"
#import "UserCenterController.h"
#import "FAQController.h"
#import "ServiceController.h"
#import "Potatso-Swift.h"
#import "GetUUID.h"
#import "AreaData.h"
#import "BuyData.h"
#import "ConnectionData.h"
#import "BuySaveData.h"
#import <AVFoundation/AVFoundation.h>
#import "UMMobClick/MobClick.h"
#import "BonusView.h"

@interface MainController ()<MainViewDelegate,HttpUtilsDelegate>

@property (strong, nonatomic) HomePresenter *presenter;

@property (assign, nonatomic) int fakeType;

@property (strong, nonatomic) ConnectionData *fakeData;

@property (strong, nonatomic) ConnectionData *fakeData2;

@end


@implementation MainController{
    IndicatorView *m_indicatorView;
    MainView *m_mainView;
    ConnectionData *m_currentConnectionData;
    AVAudioPlayer *m_audioPlayer;
    NSTimer *m_timer;
    BOOL m_connectAgain;//断连后是否需要重连
    int m_userInfoState;//用户信息状态
    UserCenterController *m_buyController;
}

- (void)initUM{
    UMConfigInstance.appKey = @"59c07f76a325116dd3000054";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick setEncryptEnabled:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化友盟sdk
    [self initUM];
    
    //[NSThread sleepForTimeInterval:1.5f];
    //[[self audioPlayer] play];
    // ---------- 新增-开始 ----------
    self.presenter = [[HomePresenter alloc] init];
    [self.presenter bindToVC:self];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onVPNStatusChanged) name:@"kProxyServiceVPNStatusNotification" object:nil];
    // ---------- 新增-结束 ----------
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSInteger defaultAreaId = [userDefaultes integerForKey:@"connectionId_flow"];
    if(defaultAreaId > 0){
        [UserInfo getInstance].currentDefaultAreaId = (short)defaultAreaId;
    }else{
        [UserInfo getInstance].currentDefaultAreaId = 1;
    }
    m_currentConnectionData = nil;
    // Do any additional setup after loading the view.
    //添加HttpUtils代理
    [HttpUtils getInstance].delegate = self;
    
    //加载主界面
    [self addMainView];
    //初始化indicatorView；
    m_indicatorView = [IndicatorView indicatorView];
    [self.view addSubview:m_indicatorView];
    //发送登陆请求
    NSLog(@" uuid  is  ---> %@",[GetUUID getUUID]);
    [m_indicatorView startAnimation:self.view];
    [[HttpUtils getInstance] requestLogin:[GetUUID getUUID]];
    
    // ---------- 新增-开始 ----------
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.presenter Seven_postEmptyMsg];
        //[strongSelf onVPNStatusChanged];
        if([self.presenter Seven_isVpnOn]){
            [self.presenter Seven_StopVPN];
        }
        [self->m_mainView setConnectStates:0];
    });
    
    //[self setupFakeChangeConfig];
    //[self setSS];
    // ---------- 新增-结束 ----------
}
- (void)setupFakeChangeConfig
{
    self.fakeData = ({
        ConnectionData * data = [[ConnectionData alloc] init];
        data.ip = @"47.52.93.214";
        data.entryPort = 8989;
        data.encryptionKey = @"teddysun.com";
        data.cipherMode = @"aes-256-cfb";
        data;
    });
    
    self.fakeData2 = ({
        ConnectionData * data = [[ConnectionData alloc] init];
        data.ip = @"s1.x3x.bid";
        data.entryPort = 1025;
        data.encryptionKey = @"google";
        data.cipherMode = @"aes-256-cfb";
        data;
    });
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 20, 30, 30)];
    [self.view addSubview:button];
    button.backgroundColor = [UIColor blackColor];
    [button addTarget:self action:@selector(fakeChangeProxy) forControlEvents:UIControlEventTouchUpInside];
}

- (void)fakeChangeProxy
{
    self.fakeType = self.fakeType ? 0 : 1;
    
    if ([self.presenter Seven_isVpnOn]) {
        __weak typeof(self)weakSelf = self;
        [self.presenter Seven_SwitchVPNWithCompletion:^(NSError * _Nullable error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf changeArearAction];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf.presenter switchVPN];
            });
        }];
    } else {
        [self changeArearAction];
        if (![self.presenter Seven_isVpnOn]) {
            [self.presenter switchVPN];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

// ---------- 新增-开始 ----------
// VPN 状态切换通知响应函数
- (void)onVPNStatusChanged {
    //[m_mainView updateServiceState:[self.presenter Seven_isVpnOn]];
}
// ---------- 新增-结束 ----------

- (void)addMainView{
    m_mainView = [MainView mainView];
    [self.view addSubview:m_mainView];
    m_mainView.delegate = self;
}

// ---------- 新增-开始 ----------
/**
 切换 Proxy
 */
- (void)changeArearAction {
    // 先写个死节点。后期需要通过网络请求获取
    NSArray *proxies = [self.presenter Seven_fetchLocalProxies];
    // 本地数据为空，先添加个
    if (proxies && proxies.count) {
        [self.presenter Seven_deleteProxiesWithProxies:proxies];
    }
    
    ConnectionData *tempData;// = self.isFake ? self.fakeData : m_currentConnectionData;
//    if (!self.fakeType) {
//        tempData = self.fakeData;
//    } else {
//        tempData = self.fakeData2;
//    }
    if(m_currentConnectionData){
        tempData = m_currentConnectionData;
    }
    [self.presenter Seven_saveFakeProxyWith_ip:tempData.ip _port:tempData.entryPort _cipherMode:tempData.cipherMode _key:tempData.encryptionKey];
    NSLog(@"当前fakeType = %d,IP=>%@", self.fakeType, tempData.ip);
    proxies = [self.presenter Seven_fetchLocalProxies];
    
    Proxy *proxy = proxies.lastObject;
    [NSUserDefaults.standardUserDefaults setObject:proxy.uuid forKey:@"kSevenClientDefaultProxyId"];
    
    NSString *defaultProxyId = [NSUserDefaults.standardUserDefaults objectForKey:@"kSevenClientDefaultProxyId"];
    defaultProxyId = ([defaultProxyId isKindOfClass:[NSString class]] && defaultProxyId.length) ? defaultProxyId : @"";
    [self.presenter Seven_choose_ProxyWithProxyId:defaultProxyId];

}

// 先写个死的规则集看效果。后期需要通过网络请求获取
- (void)fakeLocalRuleSet {
    RuleSet *ruleSet = [self.presenter Seven_fetchLocalRuleSet];
    if (!ruleSet) {
        [self.presenter Seven_saveFakeRuleSet];
        ruleSet = [self.presenter Seven_fetchLocalRuleSet];
    } else {
        [self.presenter appendRuleSet:ruleSet];
    }
}

- (void)setSS{
    [self changeArearAction];
    [self fakeLocalRuleSet];
}

// ---------- 新增-结束 ----------

- (void)jumpToUserInfoView{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    UserInfoController *userInfoController = [[UserInfoController alloc] init];
    userInfoController.userInfoController_block = ^(int areaId){
        [m_mainView setRedPointVisible];
    };
    [self presentViewController:userInfoController animated:NO completion:nil];
}

- (void)jumpToAreaView{
    //跳转动画
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    //初始化areaController
    AreaController *areaController = [[AreaController alloc] init];
    //block
    //__weak typeof(self) weakSelf = self;
    areaController.change_area_block = ^(int areaId){
        if(areaId > 0){
            [UserInfo getInstance].currentDefaultAreaId = areaId;
            [self changeAreaCountry:[UserInfo getInstance].currentDefaultAreaId];
        }
    };
    [self presentViewController:areaController animated:NO completion:nil];
}

- (void)jumpToBuyView{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    m_buyController = [[UserCenterController alloc] init];
    [self presentViewController:m_buyController animated:NO completion:nil];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    BOOL isShow = [userDefaultes boolForKey:@"redPoint_flow"];
    if(!isShow){
        [userDefaultes setBool:YES forKey:@"redPoint_flow"];
    }
    [m_mainView setRedPointVisible];
}

- (void)jumpToFAQView{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    FAQController *faqController = [[FAQController alloc] init];
    [self presentViewController:faqController animated:NO completion:nil];
}

- (void)jumpToServiceView{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    ServiceController *serviceController = [[ServiceController alloc] init];
    [self presentViewController:serviceController animated:NO completion:nil];
}

//连接ss
- (void)connectFun{
    [self setSS];
    [self.presenter switchVPN];
}

//签到方法
- (void)signFun{
    if(![UserInfo getInstance].isSign){
        //发送签到请求
        [m_indicatorView startAnimation:self.view];
        [[HttpUtils getInstance] requestSign:[UserInfo getInstance].token];
    }
}

- (void)changeAreaCountry:(int)areaId{
    if([UserInfo getInstance].connectionId != areaId){
        if([self.presenter Seven_isVpnOn]){
            //如果已连接那先断链
            m_connectAgain = YES;
            [self.presenter switchVPN];
            [m_mainView updateServiceState:NO];
            [m_indicatorView startAnimation:self.view];
            [[HttpUtils getInstance] requestDisConnection:[UserInfo getInstance].token andIp:m_currentConnectionData.ip andEntryPort:m_currentConnectionData.entryPort];
        }else{
            if([self isCanConnectByTime]){
                [m_indicatorView startAnimation:self.view];
                [[HttpUtils getInstance] requestConnection:[UserInfo getInstance].token andZoneId:areaId];
            }else{
                if([self.presenter Seven_isVpnOn]){
                    [self.presenter switchVPN];
                }
            }
        }
    }
}

- (void)startHeartBeat{
    if(m_timer == nil){
        m_timer = [NSTimer scheduledTimerWithTimeInterval:[UserInfo getInstance].heartBeatInterval target:self selector:@selector(heartBeatFun) userInfo:nil repeats:YES];
        [self heartBeatFun];
    }else{
        [m_timer setFireDate:[NSDate distantPast]];
    }
}
- (void)stopHeartBeat{
    if(m_timer){
        [m_timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)heartBeatFun{
    if(m_currentConnectionData){
        [[HttpUtils getInstance] requestHeartbeat:[UserInfo getInstance].token andIp:m_currentConnectionData.ip andEntryPort:m_currentConnectionData.entryPort];
    }
}

#pragma MainView代理方法
 - (void)mainView:(MainView *)mainView andDidSelectedItem:(UIButton *)item andSelectedIndex:(int)selectedIndex{
     NSLog(@"你点击了主界面的按钮，tag = %d",selectedIndex);
     switch(selectedIndex){
         case SERVICE_BTN_MAINVIEW://客服按钮
             [self jumpToServiceView];
             //[m_mainView showAddFlowLabel:[UserInfo getInstance].signFlow];
             break;
         case FAQ_BTN_MAINVIEW://FAQ按钮
             [self jumpToFAQView];
             break;
         case AUTO_BTN_MAINVIEW://自动配置按钮
             
             break;
         case USERINFO_BTN_MAINVIEW://账户信息按钮
             [self jumpToUserInfoView];
             break;
         case BUY_BTN_MAINVIEW://购买套餐按钮
             [self jumpToBuyView];
             break;
         // ---------- 新增-开始 ----------
         case CONNECT_BTN_MAINVIEW://连接按钮
         {
             if(![self isCanConnectByTime]){
                 [self jumpToBuyView];
                 return;
             }
             if([self.presenter Seven_isVpnOn]){
                 [self.presenter switchVPN];
                 if(m_currentConnectionData != nil){
                     m_connectAgain = NO;
                     [m_indicatorView startAnimation:self.view];
                     [[HttpUtils getInstance] requestDisConnection:[UserInfo getInstance].token andIp:m_currentConnectionData.ip andEntryPort:m_currentConnectionData.entryPort];
                 }
             }else{
                 [self changeAreaCountry:[UserInfo getInstance].currentDefaultAreaId];
             }
             break;
         }
         // ---------- 新增-结束 ----------
         case CHANGEAREA_BTN_MAINVIEW://区域切换按钮
             if(![self isCanConnectByTime]){
                 [self jumpToBuyView];
                 return;
             }
             [self jumpToAreaView];
             break;
         case SIGN_BTN_MAINVIEW://每日签到按钮
             [self signFun];
             break;
             
     }
 
 }

-(BOOL)isCanConnectByTime{
    return [UserInfo getInstance].residualFlow > 0;
//    NSInteger infiniteTime = [UserInfo getInstance].infiniteTime;
//    NSInteger systemTime = [[NSDate date] timeIntervalSince1970];
//    return infiniteTime > systemTime;
}
#pragma HttpUtils代理方法
- (void)responseLogin:(NSDictionary *)dict andCode:(int)code{
    NSLog(@"HttpUtils的代理返回responseLogin,code = %d",code);
    if(code == HTTPCODE_SUCCES && dict[@"success"]){
        m_userInfoState = 0;
        NSDictionary *data = [dict objectForKey:@"data"];
        [UserInfo getInstance].token = data[@"token"];
        [UserInfo getInstance].userName = data[@"userName"];
        BOOL isFirstRegist = [data[@"justRegist"] boolValue];
        [MobClick profileSignInWithPUID:[UserInfo getInstance].userName];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(isFirstRegist){
                BonusView *bonusView = [BonusView bonusView];
                [self.view addSubview:bonusView];
            }
            [m_mainView updateServiceState:NO];
            [[HttpUtils getInstance] requestUserInfo:[UserInfo getInstance].token];
        });
    }else{
        [[HttpUtils getInstance] requestLogin:[GetUUID getUUID]];
        NSLog(@"Yes Or No : %@",dict[@"success"] ? @"Yes" : @"No");
    }
}
- (void)responseUserInfo:(NSDictionary *)dict andCode:(int)code{
    NSLog(@"HttpUtils的代理返回responseUserInfo,code = %d",code);
    if(code == HTTPCODE_SUCCES && dict[@"success"]){
        NSDictionary *data = [dict objectForKey:@"data"];
        [UserInfo getInstance].userId = data[@"id"];
        [UserInfo getInstance].uniqueId = data[@"uniqueId"];
        [UserInfo getInstance].infiniteTime = [data[@"infiniteTime"] integerValue] / 1000;
        [UserInfo getInstance].residualFlow = [data[@"residualFlow"] floatValue] / 1024 / 1024;
        [UserInfo getInstance].isVip = [data[@"vpn"] boolValue];
        [UserInfo getInstance].isSign = [data[@"sign"] boolValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_mainView updateSignState:[UserInfo getInstance].isSign];
            [m_mainView setFlowLabelFun:[UserInfo getInstance].residualFlow];
            if(m_userInfoState == 0){
                [[HttpUtils getInstance] requestConfig:[UserInfo getInstance].token];
            }else if(m_userInfoState == 1){
                if(![self isCanConnectByTime] && m_currentConnectionData){
                    m_connectAgain = NO;
                    [self.presenter switchVPN];
                    [m_indicatorView startAnimation:self.view];
                    [[HttpUtils getInstance] requestDisConnection:[UserInfo getInstance].token andIp:m_currentConnectionData.ip andEntryPort:m_currentConnectionData.entryPort];
                }
            }else{
                [[HttpUtils getInstance] requestOrderList:[UserInfo getInstance].token];
            }
        });
    }else{
        [[HttpUtils getInstance] requestUserInfo:[UserInfo getInstance].token];
    }
}

- (void)responseConfig:(NSDictionary *)dict andCode:(int)code{
    NSLog(@"HttpUtils的代理返回responseConfig,code = %d",code);
    if(code == HTTPCODE_SUCCES){
        for (NSDictionary * dic in dict) {
            if([dic[@"key"] isEqualToString:@"sign.infinite"]){
                [UserInfo getInstance].signFlow = [dic[@"value"] intValue];
            }else if([dic[@"key"] isEqualToString:@"heartbeat.interval"]){
                [UserInfo getInstance].heartBeatInterval = [dic[@"value"] intValue];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_mainView updateSignFlow:[UserInfo getInstance].signFlow];
            [[HttpUtils getInstance] requestZone:[UserInfo getInstance].token];
        });
    }else{
        [[HttpUtils getInstance] requestConfig:[UserInfo getInstance].token];
    }
}
- (void)responseZone:(NSDictionary *)dict andCode:(int)code{
    NSLog(@"HttpUtils的代理返回responseZone,code = %d",code);
    if(code == HTTPCODE_SUCCES && dict[@"success"]){
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        NSArray * arr = [dict objectForKey:@"data"];
        for (NSDictionary * dic in arr) {
            AreaData *areaData = [[AreaData alloc] init];
            areaData.areaId = [dic[@"id"] integerValue];
            areaData.areaCode = dic[@"code"];
            areaData.areaName = dic[@"name"];
            areaData.areaCountryType = dic[@"countryType"];
            areaData.areaVip = [dic[@"vip"] boolValue];
            areaData.areaIcon = dic[@"icon"];
            areaData.areaIp = dic[@"probeIp"];
            [mutableArray addObject:areaData];
        }
        [UserInfo getInstance].areaDataArray = mutableArray;
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            [[HttpUtils getInstance] requestProducts:[UserInfo getInstance].token];
        });
    }else{
        [[HttpUtils getInstance] requestZone:[UserInfo getInstance].token];
    }
}
- (void)responseSign:(NSDictionary *)dict andCode:(int)code{
    dispatch_async(dispatch_get_main_queue(), ^{
        [m_indicatorView endAnimation:self.view];
    });
    NSLog(@"HttpUtils的代理返回responseSign,code = %d",code);
    if(code == HTTPCODE_SUCCES && dict[@"success"]){
        NSDictionary *data = [dict objectForKey:@"data"];
        //[UserInfo getInstance].residualFlow = [data[@"residualFlow"] floatValue] / 1024 / 1024;
        [UserInfo getInstance].infiniteTime = [data[@"infiniteTime"] integerValue] / 1000;
        [UserInfo getInstance].isSign = YES;
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_mainView updateSignState:[UserInfo getInstance].isSign];
            [m_mainView setEndTimeFun:[UserInfo getInstance].infiniteTime];
            [m_mainView showAddFlowLabel:[UserInfo getInstance].signFlow];
        });
    }else{
        NSLog(@"Yes Or No : %@",dict[@"success"] ? @"Yes" : @"No");
    }
}

- (void)responseProducts:(NSDictionary *)dict andCode:(int)code{
    NSLog(@"HttpUtils的代理返回responseProducts,code = %d",code);
    if(code == HTTPCODE_SUCCES){
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        for (NSDictionary * dic in dict) {
            BuyData *buyData = [[BuyData alloc] init];
            buyData.id = [dic[@"id"] integerValue] - 5;
            buyData.productId = dic[@"productId"];
            buyData.productName = dic[@"productName"];
            buyData.priceDescription = dic[@"priceDescription"];
            buyData.price = [dic[@"price"] floatValue];
            buyData.productType = dic[@"productType"];
            buyData.productContent = dic[@"productContent"];
            buyData.productPresent = dic[@"productPresent"];
            buyData.hasPurchased = [dic[@"hasPurchased"] boolValue];
            [mutableArray addObject:buyData];
            if([dic[@"id"] integerValue] == 6){
                [UserInfo getInstance].isNewUserBuy = buyData.hasPurchased;
            }
        }
        [UserInfo getInstance].buyDataArray = mutableArray;
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_mainView updateNewUserInfo:[UserInfo getInstance].isNewUserBuy];
            //获取购买记录
            [[HttpUtils getInstance] requestOrderList:[UserInfo getInstance].token];
        });
    }else{
       [[HttpUtils getInstance] requestProducts:[UserInfo getInstance].token];
    }
}

- (void)responseConnection:(NSDictionary *)dict andCode:(int)code{
    dispatch_async(dispatch_get_main_queue(), ^{
        [m_indicatorView endAnimation:self.view];
    });
    NSLog(@"HttpUtils的代理返回responseConnection,code = %d",code);
    if(code == HTTPCODE_SUCCES){
        if(m_currentConnectionData == nil){
            m_currentConnectionData = [[ConnectionData alloc] init];
        }
        m_currentConnectionData.ip = dict[@"ip"];
        m_currentConnectionData.entryPort = [dict[@"entryPort"] intValue];
        m_currentConnectionData.encryptionKey = dict[@"encryptionKey"];
        m_currentConnectionData.cipherMode = dict[@"cipherMode"];
        [UserInfo getInstance].connectionId = [UserInfo getInstance].currentDefaultAreaId;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:[UserInfo getInstance].connectionId forKey:@"connectionId"];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            [self connectFun];
            [self startHeartBeat];
            if(m_mainView){
                [m_mainView connectFun];
            }
        });
    }else{
        
    }
}

- (void)responseDisConnection:(NSDictionary *)dict andCode:(int)code{
    dispatch_async(dispatch_get_main_queue(), ^{
        [m_indicatorView endAnimation:self.view];
    });
    NSLog(@"HttpUtils的代理返回responseDisConnection,code = %d",code);
    if(code == HTTPCODE_SUCCES){
        m_currentConnectionData = nil;
        [UserInfo getInstance].connectionId = 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            if(m_mainView){
                [m_mainView connectFun];
                [m_mainView stopPing];
            }
            [self stopHeartBeat];
            if(m_connectAgain){
                [NSThread sleepForTimeInterval:1.0f];
                [self changeAreaCountry:[UserInfo getInstance].currentDefaultAreaId];
            }
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[HttpUtils getInstance] requestDisConnection:[UserInfo getInstance].token andIp:m_currentConnectionData.ip andEntryPort:m_currentConnectionData.entryPort];
        });
    }
}
- (void)responseOrderList:(NSDictionary *)dict andCode:(int)code{
    NSLog(@"HttpUtils的代理返回responseOrderList,code = %d",code);
    if(code == HTTPCODE_SUCCES){
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        for (NSDictionary * dic in dict) {
            BuySaveData *data = [[BuySaveData alloc] init];
            data.id = [dic[@"id"] integerValue];
            data.orderId = dic[@"orderId"];
            data.orderName = dic[@"orderTitle"];
            data.price = [dic[@"price"] floatValue];
            data.orderTime = dic[@"orderTime"];
            data.orderStatus = dic[@"orderStatus"];
            [mutableArray addObject:data];
        }
        [UserInfo getInstance].buySaveArray = mutableArray;
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_indicatorView endAnimation:self.view];
            
            NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
            NSInteger _orderID = [userDefaultes integerForKey:@"orderID_flow"];
            if(_orderID > 0){
                NSString *storeReceipt = [userDefaultes objectForKey:@"storeReceipt_flow"];
                [[HttpUtils getInstance] requestReviseOrder:[UserInfo getInstance].token andOrderId:_orderID andStoreReceipt:storeReceipt];
            }
        });
    }else{
        [[HttpUtils getInstance] requestOrderList:[UserInfo getInstance].token];
    }
}

- (void)responseHeartbeat:(NSDictionary *)dict andCode:(int)code{
    NSLog(@"心跳返回");
    dispatch_async(dispatch_get_main_queue(), ^{
        m_userInfoState = 1;
        [[HttpUtils getInstance] requestUserInfo:[UserInfo getInstance].token];
    });
}

- (void)responseOrder:(NSDictionary *)dict andCode:(int)code{
    NSLog(@"responseOrder");
    if(code == HTTPCODE_SUCCES){
        NSInteger _id = [dict[@"id"] integerValue];
        NSString *orderId = dict[@"orderId"];
        if(m_buyController){
            [m_buyController buyFun:orderId andId:_id];
        }
    }else{
        
    }
}

- (void)responseReviseOrder:(NSDictionary *)dict andCode:(int)code{
    NSLog(@"responseReviseOrder");
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSInteger _orderID = [userDefaultes integerForKey:@"orderID_flow"];
    if(_orderID > 0){
        [userDefaultes setInteger:-1 forKey:@"orderID_flow"];
    }
    if(code == HTTPCODE_SUCCES){
        m_userInfoState = 2;
        [[HttpUtils getInstance] requestUserInfo:[UserInfo getInstance].token];
        [[HttpUtils getInstance] requestProducts:[UserInfo getInstance].token];
    }else{
        
    }
}

- (void)closeVPN{
    if([self.presenter Seven_isVpnOn]){
//        [self.presenter switchVPN];
        
        [self.presenter Seven_StopVPN];
        [NSThread sleepForTimeInterval:3.0f];
    }
    NSLog(@"swift-->oc");
}

#pragma mark - 音频播放，让后台一直运行
- (AVAudioPlayer *)audioPlayer{
    if (m_audioPlayer == nil) {
        dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_sync(dispatchQueue, ^(void) {
            NSError *audioSessionError = nil;
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            //激活会话
            [audioSession setActive:true error:nil];
            if ([audioSession setCategory:AVAudioSessionCategoryPlayback error:&audioSessionError]){
                NSLog(@"成功设置音频对话.");
            } else {
                NSLog(@"设置音频对话失败");
            }
            
            NSBundle *mainBundle = [NSBundle mainBundle];
            NSString *filePath = [mainBundle pathForResource:@"timeBlankSound" ofType:@"mp3"];
            NSData *fileData = [NSData dataWithContentsOfFile:filePath];
            NSError *error = nil;
            
            m_audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
            
            if (m_audioPlayer != nil){
                m_audioPlayer.delegate = self;
                //让它无限循环播放
                [m_audioPlayer setNumberOfLoops:-1];
                if ([m_audioPlayer prepareToPlay] && [m_audioPlayer play]){
                    NSLog(@"成功播放");
                } else {
                    NSLog(@"播放失败");
                }
            }
        });
    }
    return m_audioPlayer;
}

//内存不足时会调用此方法
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)dealloc{
    NSLog(@"MainController被销毁");
}
@end
