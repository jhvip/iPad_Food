//
//  DishInfo.m
//  iPad-Food
//
//  Created by 吴鹏先 on 16/3/31.
//  Copyright © 2016年 wpx. All rights reserved.
//

#import "DishInfo.h"

@implementation DishInfo

+(NSArray *)dishInfoSet:(NSArray *)dishList{
    NSMutableArray *dishArray=[NSMutableArray array];
    for (int i=0; i<dishList.count; i++) {
        DishInfo *dishInfo=[DishInfo dishSet:dishList[i]];
        [dishArray addObject:dishInfo];
    }
    return dishArray;
}




+(DishInfo *)dishSet:(NSDictionary *)dict{
    DishInfo *menuInfo=[[DishInfo alloc]init];
    menuInfo.dishDetail=[dict objectForKey:@"dish_detail"];
    menuInfo.dishImage=[dict objectForKey:@"dish_pic"];
    menuInfo.dishMoney=[dict objectForKey:@"dish_price"];;
    menuInfo.dishTitle=[dict objectForKey:@"dish_name"];
    menuInfo.dishNo=[dict objectForKey:@"dish_no"];
    menuInfo.dishMany=@"0";
    return menuInfo;
}

@end
