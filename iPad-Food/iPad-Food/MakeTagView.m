//
//  MakeTagView.m
//  iPad-Food
//
//  Created by 蒋豪 on 16/4/6.
//  Copyright © 2016年 wpx. All rights reserved.
//

#import "MakeTagView.h"
#import "STPopup.h"
@interface MakeTagView ()

@property (weak, nonatomic) IBOutlet UILabel *dishNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *dishMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dishNumLabel;

@property (weak, nonatomic) IBOutlet UIView *tasteView;

@property (weak, nonatomic) IBOutlet UIView *methodView;
@property (weak, nonatomic) IBOutlet UIView *tabooView;

@end

@implementation MakeTagView


- (instancetype)init
{
    if (self = [super init]) {
        self.contentSizeInPopup = CGSizeMake(0,0);
        self.landscapeContentSizeInPopup = CGSizeMake(550, 650);
       
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 初始化按钮 并关联按钮事件
-(void)initButton{
    NSArray *viewList=[NSArray arrayWithObjects:self.tasteView,self.methodView,self.tabooView, nil];
    for (UIView *view in viewList) {
        for (UIButton *but in view.subviews) {
            [but.layer setBorderColor:[UIColor blackColor].CGColor];
            [but.layer setBorderWidth:1];
            [but.layer setCornerRadius:5];
            [but.layer setMasksToBounds:YES];
            
            if ([view isEqual:self.tasteView]) {
                [but addTarget:self action:@selector(oneClick:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [but addTarget:self action:@selector(manyClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }
    }
    
}


- (IBAction)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSMutableArray *tagList=[NSMutableArray array];
         NSArray *viewList=[NSArray arrayWithObjects:self.tasteView,self.methodView,self.tabooView, nil];
        for (UIView *view in viewList) {
            for (UIButton *but in view.subviews) {
                if (but.selected) {
                    [tagList addObject:but.titleLabel.text];
                }
            }
        }
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:self.dishNo,@"dishNo",tagList,@"tagList",nil];
        //[dic setValue:self.dishNo forKey:@"dishNo"];
        //[dic setValue:tagList forKey:@"tagList"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"tagInfo" object:dic];
        
    }];
}

#pragma mark 点击事件
-(void)oneClick:(UIButton*)sender{
    
    for (UIButton *but in self.tasteView.subviews) {
        but.selected=NO;
        but.backgroundColor=[UIColor clearColor];
    }
    sender.backgroundColor=[UIColor greenColor];
    sender.selected=YES;
}

-(void)manyClick:(UIButton*)sender{
    
    sender.selected=!sender.selected;
    if (sender.selected) {
        sender.backgroundColor=[UIColor greenColor];
    }else{
        sender.backgroundColor=[UIColor clearColor];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
