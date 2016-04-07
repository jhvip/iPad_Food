//
//  PlaceOrderViewCell.m
//  iPad-Food
//
//  Created by 蒋豪 on 16/4/7.
//  Copyright © 2016年 wpx. All rights reserved.
//

#import "PlaceOrderViewCell.h"

@interface PlaceOrderViewCell()

@property (weak, nonatomic) IBOutlet UILabel *dishNamelabel;
@property (weak, nonatomic) IBOutlet UILabel *dishMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dishNumLabel;


@end

@implementation PlaceOrderViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)placeOrderViewSetInfo:(NSDictionary *)dict{
    
    self.dishNamelabel.text=[dict objectForKey:@"name"];
    NSString *money=[dict objectForKey:@"acountnum"];
    self.dishMoneyLabel.text=[NSString stringWithFormat:@"%@元/份",money];
    NSString *num=[dict objectForKey:@"manynum"];
    self.dishNumLabel.text=[NSString stringWithFormat:@"%@份",num];
}



@end
