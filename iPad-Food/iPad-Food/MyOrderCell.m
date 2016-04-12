//
//  MyOrderCell.m
//  iPad-Food
//
//  Created by 蒋豪 on 16/4/12.
//  Copyright © 2016年 wpx. All rights reserved.
//

#import "MyOrderCell.h"

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

-(void)setMyOrderCell:(NSString *)info{
    self.orderNumLabel.text=info;
}


@end
