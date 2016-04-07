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

@property (nonatomic,strong)NSDictionary *orderInfo;


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
    self.orderInfo=dict;
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
    [self changeNum:sender];
    
    //添加长按手势
    UILongPressGestureRecognizer *gestureRecognizer=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handelPress:)];
    //gestureRecognizer.allowableMovement=0.001;
    gestureRecognizer.minimumPressDuration=0.1;
    [sender addGestureRecognizer:gestureRecognizer];
    
}
//长按手势响应
-(void)handelPress:(UILongPressGestureRecognizer*)sender{
    UIButton *but=(UIButton*)[sender view];
    [self changeNum:but];
}

-(void)changeNum:(UIButton*)but{
    NSInteger num=[self.numTextField.text intValue];
    if (but.tag==0&num>1) {
        num--;
    }else if(but.tag==1){
        num++;
    }
    self.numTextField.text=[NSString stringWithFormat:@"%ld",num];
    
    if ([self.delegate respondsToSelector:@selector(orderViewChangeInfo:withNum:)]) {
        [self.delegate orderViewChangeInfo:self.dishNo withNum:self.numTextField.text];
    }

}



- (IBAction)makeTag:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(orderViewMakeTag:)]) {
        [self.delegate orderViewMakeTag:self.orderInfo];
    }
    
}



@end
