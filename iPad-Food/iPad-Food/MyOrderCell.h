//
//  MyOrderCell.h
//  iPad-Food
//
//  Created by 蒋豪 on 16/4/12.
//  Copyright © 2016年 wpx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyOrderModel;
@interface MyOrderCell : UITableViewCell

@property(nonatomic,strong)MyOrderModel *orderInfo;

-(void)setMyOrderCell:(MyOrderModel*)info;

@end
