//
//  OrderDetailCell.h
//  iPad-Food
//
//  Created by 蒋豪 on 16/4/13.
//  Copyright © 2016年 wpx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyOrderModel;
@interface OrderDetailCell : UITableViewCell

-(void)setCellInfo:(NSDictionary *)deatilInfo withOrderInfo:(MyOrderModel*)orderInfo;

@end
