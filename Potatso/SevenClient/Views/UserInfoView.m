//
//  UserInfoView.m
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/19.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import "UserInfoView.h"
#import "UserInfo.h"

@implementation UserInfoView{
    UIImageView *m_redPointImage;
}

+ (id)userInfoView
{
    UserInfoView *userInfoView = [[UserInfoView alloc] init];
    return userInfoView;
}

- (void)btnTouch:(UIButton*)btn
{
    [_delegate userInfoView:self andDidSelectedItem:btn andSelectedIndex:(short)btn.tag];
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
    backBtn.tag = BACK_BTN_USERINFOVIEW;
    [self addSubview:backBtn];
    
    //账户信息文本
    UILabel *labelLogo = [[UILabel alloc] init];
    selfX = self.frame.size.width / 3;
    selfW = self.frame.size.width / 3;
    labelLogo.frame = CGRectMake(selfX, selfY, selfW, selfH);
    labelLogo.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:18.0];
    labelLogo.text = @"我的会员";
    labelLogo.textAlignment = NSTextAlignmentCenter;
    labelLogo.textColor = [UIColor whiteColor];
    [self addSubview:labelLogo];
}

- (void)addTableView{
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat selfW = self.frame.size.width * 0.94;
    CGFloat selfH = self.frame.size.height;
    CGFloat selfX = self.frame.size.width * 0.03;
    CGFloat selfY = rectStatus.size.height * 2.5;
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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:indexPath.section != 3 ? UITableViewCellStyleSubtitle : UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame_3"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:16];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:14];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:160/255.0 green:180/255.0 blue:205/255.0 alpha:1];
    UIImage *icon = nil;
    CGFloat _h = tableView.frame.size.width * 0.18 * 0.7;
    CGSize itemSize = CGSizeMake(_h, _h);
    CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
    if(indexPath.section == 0){
        cell.textLabel.text = @"我的会员";
        cell.detailTextLabel.text = @"自动生成，跟随设备";
        icon = [UIImage imageNamed:@"icon01"];
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
        [icon drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cell.accessoryType = UITableViewCellAccessoryNone;
        UILabel *userLabel = [[UILabel alloc] init];
        userLabel.frame = CGRectMake(tableView.frame.size.width * 0.7, cell.frame.size.height * 0.3, tableView.frame.size.width * 0.25, cell.frame.size.height * 0.5);
        userLabel.textColor = [UIColor whiteColor];
        userLabel.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:16.0];
        userLabel.text = [UserInfo getInstance].userName;
        userLabel.adjustsFontSizeToFitWidth = YES;
        userLabel.textAlignment = NSTextAlignmentRight;
        [cell addSubview:userLabel];
    }else if(indexPath.section == 1){
        cell.textLabel.text = @"会员中心";
        cell.detailTextLabel.text = @"极速体验，优惠享不停";
        icon = [UIImage imageNamed:@"icon02"];
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
        [icon drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        CGFloat tableView_H = tableView.frame.size.width * 0.18;
        CGFloat selfW = tableView_H * 0.2;
        CGFloat selfH = selfW;
        CGFloat selfX = _h * 1.2;
        CGFloat selfY = tableView_H * 0.2 - selfH * 0.5;
        m_redPointImage = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
        m_redPointImage.image = [UIImage imageNamed:@"rp"];
        [cell addSubview:m_redPointImage];
        [self updateRedPoint];
    }
//    else if(indexPath.section == 2){
//        cell.textLabel.text = @"分享";
//        cell.detailTextLabel.text = @"每日分享，获得免费加速时间";
//        icon = [UIImage imageNamed:@"animation1"];
//        UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
//        [icon drawInRect:imageRect];
//        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
    else{
        itemSize = CGSizeMake(_h * 0.8, _h * 0.8);
        imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
        icon = [UIImage imageNamed:indexPath.row == 0 ? @"iconA1" : @"iconA2"];
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
        [icon drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = indexPath.row == 0 ? @"反馈意见" : @"购买记录";
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor clearColor];
}
// 一共有多少个分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
    //return 4;
}
//第section分区一共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //if(section > 2){
    if(section == 2){
        return 2;
    }
    return 1;
}
//某一行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    //if(indexPath.section == 3){
    if(indexPath.section == 2){
        height = tableView.frame.size.width * 0.13;
    }else{
        height = tableView.frame.size.width * 0.18;
    }
    return height;
}
//选中了UITableView的某一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        BOOL isShow = [userDefaultes boolForKey:@"redPoint_flow"];
        if(!isShow){
            [userDefaultes setBool:YES forKey:@"redPoint_flow"];
        }
        [self updateRedPoint];
        [_delegate userInfoView:self andDidSelectedItem:nil andSelectedIndex:USERCENTER_BTN_USERINFOVIEW];
    }
//    else if(indexPath.section == 2){
//        [_delegate userInfoView:self andDidSelectedItem:nil andSelectedIndex:SHARE_BTN_USERINFOVIEW];
//    }
    else if(indexPath.section == 2){
        if(indexPath.row == 0){
            [_delegate userInfoView:self andDidSelectedItem:nil andSelectedIndex:SERVICE_BTN_USERINFOVIEW];
        }else{
            [_delegate userInfoView:self andDidSelectedItem:nil andSelectedIndex:BUYSAVE_BTN_USERINFOVIEW];
        }
    }
}
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0;
    if(section == 0){
        height = 20;
//    }else if(section == 3){
    }else if(section == 2){
        height = 40;
    }else{
        height = 5;
    }
    return height;//section头部高度
}

//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0;
    if(section == 0){
        height = 20;
//    }else if(section == 3){
    }else if(section == 2){
        height = 40;
    }else{
        height = 5;
    }
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, height)];
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

- (void)updateRedPoint{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    BOOL isShow = [userDefaultes boolForKey:@"redPoint_flow"];
    m_redPointImage.hidden = isShow;
}

-(NSString*)getCurrentTime:(NSInteger)utfTime{
    NSInteger _utfTime = utfTime / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_utfTime];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *str = [format stringFromDate:date];
    return str;
}

//当视图即将被加载到父试图上去的时候，系统会自动调用
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    self.frame = newSuperview.frame;
    self.backgroundColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1];
    //添加顶部菜单栏
    [self addTopTabbar];
    //添加信息列表
    [self addTableView];
    
}

- (void)dealloc{
    NSLog(@"UserInfoView被销毁");
}
@end
