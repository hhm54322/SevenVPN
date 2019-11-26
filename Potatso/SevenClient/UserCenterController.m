//
//  UserCenterController.m
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/28.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import "UserCenterController.h"
#import "UserCenterView.h"
#import "IAPHelper.h"
#import "IAPShare.h"
#import "UserInfo.h"
#import "IndicatorView.h"
#import "HttpUtils.h"
#import "BuyData.h"

@interface UserCenterController ()<UserCenterViewDelegate>

@end

@implementation UserCenterController{
    UserCenterView *m_userCenterView;
    IndicatorView *m_indicatorView;
    int m_buyNum;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(![IAPShare sharedHelper].iap) {
        NSSet* dataSet = [[NSSet alloc] initWithObjects:
                          @"6_throughput_0001_01000",
                          @"7_throughput_0018_00700",
                          @"8_throughput_0088_04000",
                          nil];
        
        [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
    }
    m_indicatorView = [IndicatorView indicatorView];
    [self.view addSubview:m_indicatorView];
    [self addUserCenterView];
}

- (void)addUserCenterView{
    m_userCenterView = [UserCenterView userCenterView];
    [self.view addSubview:m_userCenterView];
    m_userCenterView.delegate = self;
}

- (void)backFun{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma FAQView代理方法
- (void)btnClick:(int)type andSubType:(int)subType{
    switch (type) {
        case BACK_BTN_USERCENTERVIEW:
            [self backFun];
            break;
        case BUY_BTN_USERCENTERVIEW:
            m_buyNum = subType;
            [m_indicatorView startAnimation:self.view];
            [[HttpUtils getInstance] requestOrder:[UserInfo getInstance].token andProductId:[NSString stringWithFormat:subType == 1 ? @"6_throughput_0001_01000" : subType == 2 ? @"7_throughput_0018_00700" : @"8_throughput_0088_04000"]];
            //[self buyFun:subType];
            break;
        default:
            break;
    }
}

- (void)buyFun:(NSString *)orderId andId:(NSInteger)_id{
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
     {
         if(response.products.count > 0 ) {
//             switch (index) {
//                 case 1:
//                     [MobClick event:@"click_buy_6"];
//                     break;
//                 case 2:
//                     [MobClick event:@"click_buy_18"];
//                     break;
//                 case 3:
//                     [MobClick event:@"click_buy_50"];
//                     break;
//                 case 4:
//                     [MobClick event:@"click_buy_88"];
//                     break;
//                 case 5:
//                     [MobClick event:@"click_buy_158"];
//                     break;
//                 default:
//                     break;
//             }
             
             //取出第一件商品id
             SKProduct *product = response.products[m_buyNum - 1];
             
             [[IAPShare sharedHelper].iap buyProduct:product
                                        onCompletion:^(SKPaymentTransaction* trans){
                                            if(trans.error)
                                            {
                                            }
                                            else if(trans.transactionState == SKPaymentTransactionStatePurchased) {
                                                NSLog(@"购买成功");
                                                
//                                                switch (index) {
//                                                    case 1:
//                                                        [MobClick event:@"success_buy_6"];
//                                                        [MobClick event:@"income" attributes:nil counter:6];
//                                                        break;
//                                                    case 2:
//                                                        [MobClick event:@"success_buy_18"];
//                                                        [MobClick event:@"income" attributes:nil counter:18];
//                                                        break;
//                                                    case 3:
//                                                        [MobClick event:@"success_buy_50"];
//                                                        [MobClick event:@"income" attributes:nil counter:50];
//                                                        break;
//                                                    case 4:
//                                                        [MobClick event:@"success_buy_88"];
//                                                        [MobClick event:@"income" attributes:nil counter:88];
//                                                        break;
//                                                    case 5:
//                                                        [MobClick event:@"success_buy_158"];
//                                                        [MobClick event:@"income" attributes:nil counter:158];
//                                                        break;
//                                                    default:
//                                                        break;
//                                                }
                                                
                                                // 这个 receipt 就是内购成功 苹果返回的收据
                                                NSData *receipt = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                                                NSLog(@"%@",receipt);
                                                NSString *receiptBase64 = [receipt base64EncodedStringWithOptions:0];
                                                NSLog(@"%@",receiptBase64);
                                                //发送验证
//                                                BuyData *buyData = [[UserInfo getInstance].buyDataArray objectAtIndex:index - 1];
                                                
                                                NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
                                                [userDefaultes setInteger:_id forKey:@"orderID_flow"];
                                                [userDefaultes setObject:receiptBase64 forKey:@"storeReceipt_flow"];
                                                
                                                if(![UserInfo getInstance].isNewUserBuy && m_buyNum == 1){
                                                    [UserInfo getInstance].isNewUserBuy = YES;
                                                    [m_userCenterView updateTableView];
                                                }
                                                
                                                [[HttpUtils getInstance] requestReviseOrder:[UserInfo getInstance].token andOrderId:_id andStoreReceipt:receiptBase64];
                                            }
                                            else if(trans.transactionState == SKPaymentTransactionStateFailed) {
                                                if (trans.error.code == SKErrorPaymentCancelled) {
                                                }else if (trans.error.code == SKErrorClientInvalid) {
                                                }else if (trans.error.code == SKErrorPaymentInvalid) {
                                                }else if (trans.error.code == SKErrorPaymentNotAllowed) {
                                                }else if (trans.error.code == SKErrorStoreProductNotAvailable) {
                                                }else{
                                                }
                                            }
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [m_indicatorView endAnimation:self.view];
                                            });
                                        }];
         }else{
             //  ..未获取到商品
             NSLog(@"..未获取到商品");
         }
     }];
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
    NSLog(@"UserCenterController被销毁");
}

@end
