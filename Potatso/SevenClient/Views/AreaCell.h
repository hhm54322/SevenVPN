//
//  AreaCell.h
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/24.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaData.h"

@class AreaCell;

//代理方法
@protocol AreaCellDelegate <NSObject>

- (void)areaCell:(int)selectedIndex;

@end

@interface AreaCell : UITableViewCell

@property(nonatomic,assign)AreaData *dict_1;

@property(nonatomic,assign)AreaData *dict_2;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,assign)id<AreaCellDelegate> delegate;

@end
