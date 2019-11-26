//
//  UserCenterView.m
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/19.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import "UserCenterView.h"
#import "UserInfo.h"

@implementation UserCenterView

+ (id)userCenterView
{
    UserCenterView* userCenterView = [[self alloc] init];
    return userCenterView;
}

- (void)btnBack:(UIButton*)btn{
    [_delegate btnClick:BACK_BTN_USERCENTERVIEW andSubType:0];
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
    [backBtn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    
    //账户信息文本
    UILabel *labelLogo = [[UILabel alloc] init];
    selfX = self.frame.size.width / 3;
    selfW = self.frame.size.width / 3;
    labelLogo.frame = CGRectMake(selfX, selfY, selfW, selfH);
    labelLogo.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:18.0];
    labelLogo.text = @"会员中心";
    labelLogo.textAlignment = NSTextAlignmentCenter;
    labelLogo.textColor = [UIColor whiteColor];
    [self addSubview:labelLogo];
}

- (void)addInfoList{
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat selfX = self.frame.size.width * 0.03;
    CGFloat selfY = rectStatus.size.height * 2.9;
    CGFloat selfW = self.frame.size.width * 0.94;
    CGFloat selfH = rectStatus.size.height;
    //用户账号文本
    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    userName.textAlignment = NSTextAlignmentLeft;
    userName.textColor = [UIColor colorWithRed:176/255.0 green:226/255.0 blue:255/255.0 alpha:1];
    userName.adjustsFontSizeToFitWidth = YES;
    userName.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:16.0];
    userName.text = [NSString stringWithFormat:@"用户:%@",[UserInfo getInstance].userName];
    [self addSubview:userName];
    //加速服务文本
    selfY = rectStatus.size.height * 4.3;
    UILabel *speedDes = [[UILabel alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    speedDes.textAlignment = NSTextAlignmentLeft;
    speedDes.textColor = [UIColor colorWithRed:176/255.0 green:226/255.0 blue:255/255.0 alpha:1];
    speedDes.adjustsFontSizeToFitWidth = YES;
    speedDes.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:16.0];
    speedDes.text = @"加速服务";
    [self addSubview:speedDes];
    
    //免费用户文本
    selfW = self.frame.size.width * 0.2;
    selfH = rectStatus.size.height;
    selfX = self.frame.size.width * 0.4;
    selfY = rectStatus.size.height * 5.7;
    UILabel *freeUserDes = [[UILabel alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    freeUserDes.textAlignment = NSTextAlignmentCenter;
    freeUserDes.textColor = [UIColor whiteColor];
    freeUserDes.adjustsFontSizeToFitWidth = YES;
    freeUserDes.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:14.0];
    freeUserDes.text = @"免费用户";
    [self addSubview:freeUserDes];
    
    //VIP用户文本
    selfX = self.frame.size.width * 0.03 + self.frame.size.width * 0.94 * 0.7;
    selfY = rectStatus.size.height * 5.7;
    UILabel *vipUserDes = [[UILabel alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    vipUserDes.textAlignment = NSTextAlignmentCenter;
    vipUserDes.textColor = [UIColor whiteColor];
    vipUserDes.adjustsFontSizeToFitWidth = YES;
    vipUserDes.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:14.0];
    vipUserDes.text = @"VIP用户";
    [self addSubview:vipUserDes];
    
    //列表1
    selfW = self.frame.size.width * 0.94;
    selfH = rectStatus.size.height * 1.8;
    selfX = self.frame.size.width * 0.03;
    selfY = rectStatus.size.height * 7.1;
    UIImageView *backGround_1 = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    backGround_1.image = [UIImage imageNamed:@"frame_5"];
    [self addSubview:backGround_1];
    
    selfW = self.frame.size.width * 0.2;
    selfH = rectStatus.size.height;
    selfX = backGround_1.frame.size.width * 0.06;
    selfY = rectStatus.size.height * 0.45;
    UILabel *bg_1_text = [[UILabel alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    bg_1_text.textAlignment = NSTextAlignmentLeft;
    bg_1_text.textColor = [UIColor whiteColor];
    bg_1_text.adjustsFontSizeToFitWidth = YES;
    bg_1_text.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:14.0];
    bg_1_text.text = @"普通加速";
    [backGround_1 addSubview:bg_1_text];
    
    selfW = backGround_1.frame.size.height / 3;
    selfH = selfW;
    selfX = (backGround_1.frame.size.width * 0.06 - selfW) / 2;
    selfY = (backGround_1.frame.size.height - selfH) / 2;
    UIImageView *bg_1_image_0 = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    bg_1_image_0.image = [UIImage imageNamed:@"iconC1"];
    [backGround_1 addSubview:bg_1_image_0];
    
    selfX = (backGround_1.frame.size.width - selfW) / 2;
    UIImageView *bg_1_image_1 = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    bg_1_image_1.image = [UIImage imageNamed:@"iconC4"];
    [backGround_1 addSubview:bg_1_image_1];
    
    selfX = backGround_1.frame.size.width * 0.8 - selfW / 2;
    UIImageView *bg_1_image_2 = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    bg_1_image_2.image = [UIImage imageNamed:@"iconC4"];
    [backGround_1 addSubview:bg_1_image_2];
    
    //列表2
    selfW = self.frame.size.width * 0.94;
    selfH = rectStatus.size.height * 1.8;
    selfX = self.frame.size.width * 0.03;
    selfY = rectStatus.size.height * 8.9;
    UIImageView *backGround_2 = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    backGround_2.image = [UIImage imageNamed:@"frame_5"];
    [self addSubview:backGround_2];
    
    selfW = self.frame.size.width * 0.2;
    selfH = rectStatus.size.height;
    selfX = backGround_2.frame.size.width * 0.06;
    selfY = rectStatus.size.height * 0.5;
    UILabel *bg_2_text = [[UILabel alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    bg_2_text.textAlignment = NSTextAlignmentLeft;
    bg_2_text.textColor = [UIColor whiteColor];
    bg_2_text.adjustsFontSizeToFitWidth = YES;
    bg_2_text.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:14.0];
    bg_2_text.text = @"Wifi优化";
    [backGround_2 addSubview:bg_2_text];
    
    selfW = backGround_2.frame.size.height / 3;
    selfH = selfW;
    selfX = (backGround_2.frame.size.width * 0.06 - selfW) / 2;
    selfY = (backGround_2.frame.size.height - selfH) / 2;
    UIImageView *bg_2_image_0 = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    bg_2_image_0.image = [UIImage imageNamed:@"iconC2"];
    [backGround_2 addSubview:bg_2_image_0];
    
    selfX = (backGround_2.frame.size.width - selfW) / 2;
    UIImageView *bg_2_image_1 = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    bg_2_image_1.image = [UIImage imageNamed:@"iconC5"];
    [backGround_2 addSubview:bg_2_image_1];
    
    selfX = backGround_2.frame.size.width * 0.8 - selfW / 2;
    UIImageView *bg_2_image_2 = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    bg_2_image_2.image = [UIImage imageNamed:@"iconC4"];
    [backGround_2 addSubview:bg_2_image_2];
    
    //列表3
    selfW = self.frame.size.width * 0.94;
    selfH = rectStatus.size.height * 1.8;
    selfX = self.frame.size.width * 0.03;
    selfY = rectStatus.size.height * 10.7;
    UIImageView *backGround_3 = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    backGround_3.image = [UIImage imageNamed:@"frame_5"];
    [self addSubview:backGround_3];
    
    selfW = self.frame.size.width * 0.2;
    selfH = rectStatus.size.height;
    selfX = backGround_3.frame.size.width * 0.06;
    selfY = rectStatus.size.height * 0.5;
    UILabel *bg_3_text = [[UILabel alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    bg_3_text.textAlignment = NSTextAlignmentLeft;
    bg_3_text.textColor = [UIColor whiteColor];
    bg_3_text.adjustsFontSizeToFitWidth = YES;
    bg_3_text.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:14.0];
    bg_3_text.text = @"4G优化";
    [backGround_3 addSubview:bg_3_text];
    
    selfW = backGround_3.frame.size.height / 3;
    selfH = selfW;
    selfX = (backGround_3.frame.size.width * 0.06 - selfW) / 2;
    selfY = (backGround_3.frame.size.height - selfH) / 2;
    UIImageView *bg_3_image_0 = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    bg_3_image_0.image = [UIImage imageNamed:@"iconC3"];
    [backGround_3 addSubview:bg_3_image_0];
    
    selfX = (backGround_3.frame.size.width - selfW) / 2;
    UIImageView *bg_3_image_1 = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    bg_3_image_1.image = [UIImage imageNamed:@"iconC5"];
    [backGround_3 addSubview:bg_3_image_1];
    
    selfX = backGround_3.frame.size.width * 0.8 - selfW / 2;
    UIImageView *bg_3_image_2 = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    bg_3_image_2.image = [UIImage imageNamed:@"iconC4"];
    [backGround_3 addSubview:bg_3_image_2];
    
    //VIP套餐文本
    selfX = self.frame.size.width * 0.03;
    selfY = rectStatus.size.height * 12.9;
    selfW = self.frame.size.width * 0.94;
    selfH = rectStatus.size.height;
    //用户账号文本
    UILabel *vipDes = [[UILabel alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    vipDes.textAlignment = NSTextAlignmentLeft;
    vipDes.textColor = [UIColor colorWithRed:176/255.0 green:226/255.0 blue:255/255.0 alpha:1];
    vipDes.adjustsFontSizeToFitWidth = YES;
    vipDes.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:16.0];
    vipDes.text = @"VIP套餐";
    [self addSubview:vipDes];
}

- (void)addBuyTableView{
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat selfW = self.frame.size.width * 0.94;
    CGFloat selfH = self.frame.size.height * 0.5;
    CGFloat selfX = self.frame.size.width * 0.03;
    CGFloat selfY = rectStatus.size.height * 14.3;
    m_tableView = [[UITableView alloc]initWithFrame:CGRectMake(selfX, selfY, selfW, selfH) style:UITableViewStyleGrouped];
    m_tableView.dataSource = self;
    m_tableView.delegate = self;
    m_tableView.backgroundColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1];
    m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_tableView.scrollEnabled = NO;
    [self addSubview:m_tableView];
}

#pragma mark - 数据源方法
//创建第section分区第row行的UITableViewCell对象(indexPath包含了section和row)
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame_3"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:20.0];
    cell.detailTextLabel.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:13.0];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    UIImage *icon = nil;
    CGFloat _h = self.frame.size.height * 0.5 * 0.3 * 0.5;
    CGSize itemSize = CGSizeMake(_h, _h);
    CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
    if(indexPath.section == 0){
        cell.textLabel.textColor = [UIColor yellowColor];
        cell.textLabel.text = @"VIP至尊包";
        cell.detailTextLabel.text = @"4000MB，可叠加购买";
        icon = [UIImage imageNamed:@"iconB3"];
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
        [icon drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UILabel *primeCost = [[UILabel alloc] init];
        primeCost.frame = CGRectMake(self.frame.size.width * 0.65, self.frame.size.height * 0.5 * 0.3 * 0.3, self.frame.size.width * 0.2, self.frame.size.height * 0.5 * 0.3 * 0.15);
        primeCost.textColor = [UIColor lightGrayColor];
        primeCost.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:12.0];
        primeCost.text = @"¥100.0";
        primeCost.adjustsFontSizeToFitWidth = YES;
        primeCost.textAlignment = NSTextAlignmentRight;
        [cell addSubview:primeCost];
        UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.76, primeCost.frame.origin.y + primeCost.frame.size.height / 2 - 0.5, self.frame.size.width * 0.09, 1)];
        lineImage.image = [UIImage imageNamed:@"frame_9"];
        [cell addSubview:lineImage];
        UILabel *costLabel = [[UILabel alloc] init];
        costLabel.frame = CGRectMake(self.frame.size.width * 0.65, self.frame.size.height * 0.5 * 0.3 * 0.5, self.frame.size.width * 0.2, self.frame.size.height * 0.5 * 0.3 * 0.25);
        costLabel.textColor = [UIColor whiteColor];
        costLabel.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:20.0];
        costLabel.text = @"¥88.0";
        costLabel.adjustsFontSizeToFitWidth = YES;
        costLabel.textAlignment = NSTextAlignmentRight;
        [cell addSubview:costLabel];
    }else if(indexPath.section == 1){
        cell.textLabel.textColor = [UIColor colorWithRed:3/255.0 green:168/255.0 blue:158/255.0 alpha:1];
        cell.textLabel.text = @"VIP畅享包";
        cell.detailTextLabel.text = @"700MB，可叠加购买";
        icon = [UIImage imageNamed:@"iconB2"];
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
        [icon drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UILabel *costLabel = [[UILabel alloc] init];
        costLabel.frame = CGRectMake(self.frame.size.width * 0.65, (self.frame.size.height * 0.5 * 0.3 - self.frame.size.height * 0.5 * 0.3 * 0.3) / 2, self.frame.size.width * 0.2, self.frame.size.height * 0.5 * 0.3 * 0.3);
        costLabel.textColor = [UIColor whiteColor];
        costLabel.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:20.0];
        costLabel.text = @"¥18.0";
        costLabel.adjustsFontSizeToFitWidth = YES;
        costLabel.textAlignment = NSTextAlignmentRight;
        [cell addSubview:costLabel];
    }else if(indexPath.section == 2){
        cell.textLabel.textColor = [UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1];
        cell.textLabel.text = @"新人优享包";
        cell.detailTextLabel.text = @"200MB，限购一次";
        icon = [UIImage imageNamed:@"iconB1"];
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
        [icon drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UILabel *costLabel = [[UILabel alloc] init];
        costLabel.frame = CGRectMake(self.frame.size.width * 0.65, (self.frame.size.height * 0.5 * 0.3 - self.frame.size.height * 0.5 * 0.3 * 0.3) / 2, self.frame.size.width * 0.2, self.frame.size.height * 0.5 * 0.3 * 0.3);
        costLabel.textColor = [UIColor whiteColor];
        costLabel.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:20.0];
        costLabel.text = @"¥  1.0";
        costLabel.adjustsFontSizeToFitWidth = YES;
        costLabel.textAlignment = NSTextAlignmentRight;
        [cell addSubview:costLabel];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor clearColor];
}
// 一共有多少个分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [UserInfo getInstance].isNewUserBuy ? 2 : 3;
}
//第section分区一共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//某一行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.frame.size.height * 0.5 * 0.3;
}
//选中了UITableView的某一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        [_delegate btnClick:BUY_BTN_USERCENTERVIEW andSubType:3];
    }else if(indexPath.section == 1){
        [_delegate btnClick:BUY_BTN_USERCENTERVIEW andSubType:2];
    }else if(indexPath.section == 2){
        [_delegate btnClick:BUY_BTN_USERCENTERVIEW andSubType:1];
    }
}
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 0 : 5;//section头部高度
}

//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, section == 0 ? 0 : 5)];
    view.backgroundColor = [UIColor clearColor];
    return view ;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)updateTableView{
    [m_tableView reloadData];
}

//当视图即将被加载到父试图上去的时候，系统会自动调用
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    self.frame = newSuperview.frame;
    self.backgroundColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1];
    //添加顶部菜单栏
    [self addTopTabbar];
    //添加信息栏
    [self addInfoList];
    //添加VIP套餐栏
    [self addBuyTableView];
}

- (void)dealloc{
    NSLog(@"UserCenterView被销毁");
}

@end
