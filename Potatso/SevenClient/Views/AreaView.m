//
//  AreaView.m
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/19.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import "AreaView.h"
#import "AreaCell.h"

@interface AreaView ()<UITableViewDelegate,UITableViewDataSource,AreaCellDelegate>

@end

@implementation AreaView

+ (id)areaView:(NSMutableArray*)areaDataArray
{
    AreaView *areaView = [[AreaView alloc] init];
    areaView.areaDataArray = areaDataArray;
    return areaView;
}

- (void)btnTouchRefresh:(UIButton*)btn
{
    [_delegate btnClick:REFRESH_BTN_AREAVIEW andSubType:0];
}

- (void)btnTouchBack:(UIButton*)btn
{
    [_delegate btnClick:BACK_BTN_AREAVIEW andSubType:0];
}

- (void)areaCell:(int)selectedIndex{
    [_delegate btnClick:CHANGE_BTN_AREAVIEW andSubType:selectedIndex];
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
    [backBtn addTarget:self action:@selector(btnTouchBack:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    
    //地区切换文本
    UILabel *labelLogo = [[UILabel alloc] init];
    selfX = self.frame.size.width / 3;
    selfW = self.frame.size.width / 3;
    labelLogo.frame = CGRectMake(selfX, selfY, selfW, selfH);
    labelLogo.text = @"地区切换";
    labelLogo.font = [UIFont fontWithName:@"ArialMT" size:18.0];
    labelLogo.textAlignment = NSTextAlignmentCenter;
    labelLogo.textColor = [UIColor whiteColor];
    [self addSubview:labelLogo];
    
    //说明文本底图
    selfX = 0;
    selfY = rectStatus.size.height * 2.5;
    selfW = self.frame.size.width;
    selfH = rectStatus.size.height * 2.5;
    UIImageView *imageDes = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    imageDes.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:imageDes];
    
    //地区切换文本
    UILabel *labelDes = [[UILabel alloc] init];
    labelDes.frame = CGRectMake(selfX, selfY, selfW, selfH);
    labelDes.adjustsFontSizeToFitWidth = YES;
    labelDes.font = [UIFont fontWithName:@"ArialMT" size:18.0];
    labelDes.text = @"切换后自动连接当前最快节点";
    labelDes.textAlignment = NSTextAlignmentCenter;
    labelDes.textColor = [UIColor blackColor];
    [self addSubview:labelDes];
}


- (void)addTableView{
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat selfX = self.frame.size.width * 0.1;
    CGFloat selfY = rectStatus.size.height * 6;
    CGFloat selfW = self.frame.size.width * 0.8;
    CGFloat selfH = self.frame.size.height - selfY - rectStatus.size.height;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW , selfH)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self addSubview:tableView];
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_areaDataArray == nil) return 0;
    return _areaDataArray.count / 2 + _areaDataArray.count % 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AreaCell *cell = [AreaCell cellWithTableView:tableView];
    cell.delegate = self;
    NSLog(@"%ld",(long)indexPath.row);
    cell.dict_1 = [_areaDataArray objectAtIndex:indexPath.row * 2];
    if(indexPath.row * 2 + 1 < _areaDataArray.count){
        cell.dict_2 = [_areaDataArray objectAtIndex:indexPath.row * 2 + 1];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.frame.size.height / 3;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AreaCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

//当视图即将被加载到父试图上去的时候，系统会自动调用
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    self.frame = newSuperview.frame;
    self.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    //添加顶部菜单栏
    [self addTopTabbar];
    //添加tableView
    [self addTableView];
    
}

- (void)dealloc{
    NSLog(@"AreaView被销毁");
}


@end
