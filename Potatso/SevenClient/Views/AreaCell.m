//
//  AreaCell.m
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/24.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import "AreaCell.h"
#import "AreaUI.h"

@interface AreaCell ()<AreaUIDelegate>

@end

@implementation AreaCell{
    AreaUI *areaUIView1;
    AreaUI *areaUIView2;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"CELL";
    AreaCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AreaCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (void)areaUI:(int)selectedIndex{
    [_delegate areaCell:selectedIndex];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self.backgroundColor = [UIColor clearColor];
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    //创建AreaUI
    areaUIView1 = [AreaUI areaUI];
    
    areaUIView2 = [AreaUI areaUI];
    return self;
}
//当视图即将被加载到父试图上去的时候，系统会自动调用
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    NSLog(@"%@",NSStringFromCGRect(newSuperview.frame));
    self.frame = CGRectMake(0, 0, newSuperview.frame.size.width, newSuperview.frame.size.height * 0.3);
    areaUIView1.frame = CGRectMake(0, 0, newSuperview.frame.size.width * 0.45, newSuperview.frame.size.width * 0.45);
    areaUIView1.dict = _dict_1;
    areaUIView1.delegate = self;
    [self addSubview:areaUIView1];
    
    if(_dict_2 != nil){
        areaUIView2.dict = _dict_2;
        areaUIView2.delegate = self;
        areaUIView2.frame = CGRectMake(newSuperview.frame.size.width * 0.55, 0, newSuperview.frame.size.width * 0.45, newSuperview.frame.size.width * 0.45);
        [self addSubview:areaUIView2];
    }
}

@end
