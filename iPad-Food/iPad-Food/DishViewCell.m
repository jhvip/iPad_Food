//
//  DishViewCell.m
//  iPad-Food
//
//  Created by 吴鹏先 on 16/3/31.
//  Copyright © 2016年 wpx. All rights reserved.
//

#import "DishViewCell.h"
#import "DishInfo.h"
#import "RequestUrl.h"

#import "UIButton+WebCache.h"

@interface DishViewCell()


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dishDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *manyLabel;

@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;

@property(nonatomic,strong)NSString *dishNO;

@end


@implementation DishViewCell

- (void)awakeFromNib {
    // Initialization code
    self.statusView.backgroundColor=[UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)makeOrder {
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSMutableArray *array=[NSMutableArray arrayWithArray:[ud objectForKey:@"dishes"]];
    int num=1;
    int index=-1;
    for (NSDictionary *dict in array) {
        if ([[dict objectForKey:@"id"]isEqualToString:self.dishNO]) {
            num = [[dict objectForKey:@"manynum"] intValue];
            num++;
            index=(int)[array indexOfObject:dict];
        }
    }
    
    NSDictionary *dishes=@{@"id":self.dishNO,@"name":self.titleLabel.text,@"acountnum":self.moneyLabel.text,@"manynum":[NSString stringWithFormat:@"%d",num]};
    if (num==1) {
        [array addObject:dishes];
    }else{
        [array replaceObjectAtIndex:index withObject:dishes];
    }
    
    [ud setObject:array forKey:@"dishes"];

    if ([self.delegate respondsToSelector:@selector(dishViewCellReloadOrder:)]) {
        [self.delegate dishViewCellReloadOrder:array];
    }
    
    
    
    
}

- (IBAction)showDetail {
    
    if ([self.delegate respondsToSelector:@selector(dishViewCellShowDetail:)]) {
        [self.delegate dishViewCellShowDetail:self.dishNO];
    } 
}

-(void)dishViewSetInfo:(DishInfo *)dishInfo{
    self.titleLabel.text=dishInfo.dishTitle;
    self.moneyLabel.text=dishInfo.dishMoney;
    self.dishDetailLabel.text=dishInfo.dishDetail;
 
    self.dishNO=dishInfo.dishNo;

    self.manyLabel.text=dishInfo.dishMany;
    NSString *url=[NSString stringWithFormat:@"http://%@/image/%@",ip,dishInfo.dishImage];
//    NSData *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
//
//    [self.imageButton setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
    
    [self.imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"photoDefault"]];
    
    
    if ([self.manyLabel.text isEqualToString:@"0"]) {
        self.statusView.hidden=YES;
    }else{
        self.statusView.hidden=NO;
    }
    
}



@end
