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
@property (weak, nonatomic) IBOutlet UITextField *otherTextField;

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

-(void)viewWillAppear:(BOOL)animated{
    self.dishNameLabel.text=[self.dishInfo objectForKey:@"name"];
    self.dishMoneyLabel.text=[self.dishInfo objectForKey:@"acountnum"];
    NSString *num=[self.dishInfo objectForKey:@"manynum"];
    self.dishNumLabel.text=[NSString stringWithFormat:@"已点%@份",num];
    NSArray *tagList=[NSArray arrayWithArray:[self.dishInfo objectForKey:@"tagList"]];
    [self loadOldTag:tagList];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initButton];
}

#pragma mark 加载之前的设置
-(void)loadOldTag:(NSArray*)tagList{
    if (tagList.count==0) {
        return;
    }
    NSArray *viewList=[NSArray arrayWithObjects:self.tasteView,self.methodView,self.tabooView, nil];
    for (UIView *view in viewList) {
        for (UIButton *but in view.subviews) {
            for (NSString *tag in tagList) {
                if ([but.titleLabel.text isEqualToString:tag]) {
                    but.selected=YES;
                    but.backgroundColor=[UIColor greenColor];
                }
            }
        }
    }
    self.otherTextField.text=[tagList lastObject];


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
        [tagList addObject:self.otherTextField.text];
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:self.dishInfo];
        [dic setValue:tagList forKey:@"tagList"];
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
