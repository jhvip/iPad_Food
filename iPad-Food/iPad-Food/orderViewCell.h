//
//  orderViewCell.h
//  iPad-Food
//
//  Created by 蒋豪 on 16/4/1.
//  Copyright © 2016年 wpx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol orderViewCellDelegate<NSObject>

-(void)orderViewDeleteInfo:(NSString*)dishNO;
-(void)orderViewChangeInfo:(NSString*)dishNo withNum:(NSString *)num;

@end

@interface orderViewCell : UITableViewCell

@property(nonatomic,weak)id<orderViewCellDelegate> delegate;

-(void)orderViewSetInfo:(NSDictionary*)dict;

@end
