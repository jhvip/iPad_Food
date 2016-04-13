//
//  MyOrderCell.m
//  iPad-Food
//
//  Created by 蒋豪 on 16/4/12.
//  Copyright © 2016年 wpx. All rights reserved.
//

#import "MyOrderCell.h"
#import "MyOrderModel.h"
@interface MyOrderCell()
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderMoney;
@end

@implementation MyOrderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMyOrderCell:(MyOrderModel *)info{
    self.orderNumLabel.text=info.orderNum;
    self.orderMoney.text=[NSString stringWithFormat:@"%@元",info.orderMoney];
    self.orderTimeLabel.text=info.orderTime;
    if ([info.orderServed isEqualToString:@"0"]) {
        self.orderStatusLabel.text=@"未支付";
    }else{
        self.orderStatusLabel.text=@"已支付";
    }
    self.orderInfo=info;
}


@end
