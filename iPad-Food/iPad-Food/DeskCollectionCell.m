//
//  DeskCollectionCell.m
//  iPad-Food
//
//  Created by 吴鹏先 on 16/4/8.
//  Copyright © 2016年 wpx. All rights reserved.
//

#import "DeskCollectionCell.h"

@interface DeskCollectionCell()
@property (weak, nonatomic) IBOutlet UILabel *deskNumLabel;

@end

@implementation DeskCollectionCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setDeskNUm:(NSString *)deskNum{
    self.deskNumLabel.text=deskNum;
}
@end
