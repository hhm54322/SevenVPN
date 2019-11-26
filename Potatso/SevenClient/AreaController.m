//
//  AreaController.m
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/22.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import "AreaController.h"
#import "AreaView.h"
#import "Potatso-Swift.h"
#import "UserInfo.h"

@interface AreaController ()<AreaViewDelegate>
// ---------- 新增-开始 ----------
@property (strong, nonatomic) HomePresenter *presenter;
// ---------- 新增-结束 ----------

@end

@implementation AreaController{
    AreaView *m_areaView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // ---------- 新增-开始 ----------
    self.presenter = [[HomePresenter alloc] init];
    // ---------- 新增-结束 ----------

    [self addAreaView];
}

- (void)addAreaView{
    m_areaView = [AreaView areaView:[UserInfo getInstance].areaDataArray];
    [self.view addSubview:m_areaView];
    m_areaView.delegate = self;
}

#pragma BuySaveView代理方法
- (void)btnClick:(int)type andSubType:(int)subType{
    switch (type) {
        case BACK_BTN_AREAVIEW:
            [self backFun:0];
            break;
        case REFRESH_BTN_AREAVIEW:
            
            break;
        // ---------- 新增-开始 ----------
        case CHANGE_BTN_AREAVIEW:
        {
//            [self changeArearAction];
//            [self fakeLocalRuleSet];
            [self backFun:subType];
            break;
        }
        // ---------- 新增-结束 ----------
        default:
            break;
    }
}

- (void)backFun:(int)areaId{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];
    if(self.change_area_block){
        [self dismissViewControllerAnimated:NO completion:^{self.change_area_block(areaId);}];
    }else{
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

//// ---------- 新增-开始 ----------
///**
// 切换 Proxy
// */
//- (void)changeArearAction {
//    // 先写个死节点。后期需要通过网络请求获取
//    NSArray *proxies = [self.presenter Seven_fetchLocalProxies];
//    // 本地数据为空，先添加个
//    if (!proxies || !proxies.count) {
//        [self.presenter Seven_saveFakeProxy];
//        proxies = [self.presenter Seven_fetchLocalProxies];
//    }
//    Proxy *proxy = proxies.firstObject;
//    [NSUserDefaults.standardUserDefaults setObject:proxy.uuid forKey:@"kSevenClientDefaultProxyId"];
//    
//    NSString *defaultProxyId = [NSUserDefaults.standardUserDefaults objectForKey:@"kSevenClientDefaultProxyId"];
//    defaultProxyId = ([defaultProxyId isKindOfClass:[NSString class]] && defaultProxyId.length) ? defaultProxyId : @"";
//    [self.presenter Seven_choose_ProxyWithProxyId:defaultProxyId];
//}
//
//// 先写个死的规则集看效果。后期需要通过网络请求获取
//- (void)fakeLocalRuleSet {
//    RuleSet *ruleSet = [self.presenter Seven_fetchLocalRuleSet];
//    if (!ruleSet) {
//        [self.presenter Seven_saveFakeRuleSet];
//        ruleSet = [self.presenter Seven_fetchLocalRuleSet];
//    } else {
//        [self.presenter appendRuleSet:ruleSet];
//    }
//}
//
//// ---------- 新增-结束 ----------

//TODO: Block Set方法(必写)
- (void)setChange_area_block:(void (^)(int))change_area_block{
    _change_area_block = change_area_block;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)dealloc{
    NSLog(@"AreaController被销毁");
}

@end
