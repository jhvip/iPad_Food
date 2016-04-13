//
//  OrderDetailCell.m
//  iPad-Food
//
//  Created by 蒋豪 on 16/4/13.
//  Copyright © 2016年 wpx. All rights reserved.
//

#import "OrderDetailCell.h"

@interface OrderDetailCell()
@property (weak, nonatomic) IBOutlet UILabel *dishMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dishMarklabel;

@property (weak, nonatomic) IBOutlet UILabel *dishName;
@end

@implementation OrderDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellInfo:(NSDictionary *)deatilInfo withOrderInfo:(MyOrderModel *)orderInfo{
    
    NSString *money=[deatilInfo objectForKey:@"dish_price"];
    NSString *num=[deatilInfo objectForKey:@"num"];
    self.dishMoneyLabel.text=[NSString stringWithFormat:@"%@*%@元",num,money];
    self.dishName.text=[deatilInfo objectForKey:@"dish_name"];
    if ([[deatilInfo objectForKey:@"mark"]isEqualToString:@""]||[[deatilInfo objectForKey:@"mark"]isEqualToString:@" "]) {
        self.dishMarklabel.text=@"无";
    }else{
        self.dishMarklabel.text=[deatilInfo objectForKey:@"mark"];
    }
}

@end
