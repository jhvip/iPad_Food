//
//  orderViewCell.m
//  iPad-Food
//
//  Created by 蒋豪 on 16/4/1.
//  Copyright © 2016年 wpx. All rights reserved.
//

#import "orderViewCell.h"

@interface orderViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (nonatomic,strong)NSString *dishNo;
@end

@implementation orderViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
/**
 *  dishes 数据存储
 *
 *  @param dict @{@"id":self.dishNO,@"name":self.titleLabel.text,@"acountnum":self.moneyLabel.text,@"manynum":[NSString stringWithFormat:@"%d",num]};
 */
-(void)orderViewSetInfo:(NSDictionary *)dict{
    self.titleLabel.text=[dict objectForKey:@"name"];
    NSString *money=[dict objectForKey:@"acountnum"];
    self.moneyLabel.text=[NSString stringWithFormat:@"%@元/份",money];
    self.numTextField.text=[dict objectForKey:@"manynum"];
    self.dishNo=[dict objectForKey:@"id"];
}


- (IBAction)deleteOrder:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(orderViewDeleteInfo:)]) {
        [self.delegate orderViewDeleteInfo:self.dishNo];
    }
}


- (IBAction)changeOrderNum:(UIButton *)sender {
    NSInteger num=[self.numTextField.text intValue];
    if (sender.tag==0&num>0) {
        num--;
    }else if(sender.tag==1){
        num++;
    }
    self.numTextField.text=[NSString stringWithFormat:@"%ld",num];
    
}



@end
