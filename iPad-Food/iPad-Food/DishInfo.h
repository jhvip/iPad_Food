//
//  DishInfo.h
//  iPad-Food
//
//  Created by 吴鹏先 on 16/3/31.
//  Copyright © 2016年 wpx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DishInfo : NSObject

@property(nonatomic,strong)NSString *dishImage;
@property(nonatomic,strong)NSString *dishMoney;
@property(nonatomic,strong)NSString *dishTitle;
@property(nonatomic,strong)NSString *dishDetail;
@property(nonatomic,strong)NSString *dishNo;
@property(nonatomic,strong)NSString *dishMany;
+(NSArray*)dishInfoSet:(NSArray*)dishList;

@end
