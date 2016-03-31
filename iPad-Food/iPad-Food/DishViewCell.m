//
//  DishViewCell.m
//  iPad-Food
//
//  Created by 蒋豪 on 16/3/31.
//  Copyright © 2016年 wpx. All rights reserved.
//

#import "DishViewCell.h"
#import "DishInfo.h"
#import "RequestUrl.h"
@interface DishViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dishDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *manyLabel;

@property (weak, nonatomic) IBOutlet UIView *statusView;

@property(nonatomic,strong)NSString *dishNO;

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
    
    self.manyLabel.text=[NSString stringWithFormat:@"%d",num];
    
    if ([self.delegate respondsToSelector:@selector(dishViewCellReloadOrder:)]) {
        [self.delegate dishViewCellReloadOrder:array];
    }
    
    
    
    
}

- (IBAction)showDetail {
    
    
}

-(void)dishViewSetInfo:(DishInfo *)dishInfo{
    self.titleLabel.text=dishInfo.dishTitle;
    self.moneyLabel.text=dishInfo.dishMoney;
    self.detailTextLabel.text=dishInfo.dishDetail;
    self.dishNO=dishInfo.dishNo;
    
    NSString *url=[NSString stringWithFormat:@"http://%@/image/%@",ip,dishInfo.dishImage];
    NSData *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    self.imageView.image=[self OriginImage:[UIImage imageWithData:imageData] scaleToSize:CGSizeMake(150, 150)];
    if ([self.manyLabel.text isEqualToString:@"0"]) {
        self.statusView.hidden=YES;
    }else{
        self.statusView.hidden=NO;
    }
    
    
    
    
}

-(UIImage *)OriginImage:(UIImage *)image scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}




@end
