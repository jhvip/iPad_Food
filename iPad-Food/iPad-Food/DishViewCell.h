//
//  DishViewCell.h
//  iPad-Food
//
//  Created by 蒋豪 on 16/3/31.
//  Copyright © 2016年 wpx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DishInfo;


@protocol DishViewCellDelegate <NSObject>
//点菜代理事件
-(void)dishViewCellReloadOrder:(NSArray*)orderList;


@end


@interface DishViewCell : UITableViewCell

@property(nonatomic,weak)id<DishViewCellDelegate> delegate;
-(void)dishViewSetInfo:(DishInfo*)dishInfo;

@end
