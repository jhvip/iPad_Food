//
//  DishViewCell.m
//  iPad-Food
//
//  Created by 蒋豪 on 16/3/31.
//  Copyright © 2016年 wpx. All rights reserved.
//

#import "DishViewCell.h"
#import "DishInfo.h"
@interface DishViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dishDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *manyLabel;

@property (weak, nonatomic) IBOutlet UIView *statusView;

@end


@implementation DishViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)makeOrder {
    
}

- (IBAction)showDetail {
    
    
}

-(void)dishViewSetInfo:(DishInfo *)dishInfo{
    self.titleLabel.text=dishInfo.dishTitle;
    self.moneyLabel.text=dishInfo.dishMoney;
    self.detailTextLabel.text=dishInfo.dishDetail;
    self.imageView.image=[UIImage imageNamed:@"blank_3"];
}

@end
