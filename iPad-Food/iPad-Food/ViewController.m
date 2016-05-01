//
//  ViewController.m
//  iPad-Food
//
//  Created by 吴鹏先 on 16/3/29.
//  Copyright © 2016年 wpx. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "DishInfo.h"
#import "DishViewCell.h"
#import "STPopup.h"
#import "DishDetailViewController.h"
#import "OrderViewController.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,DishViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSArray *dishList;

@property (weak, nonatomic) IBOutlet UILabel *orderNum;

@property (weak, nonatomic) IBOutlet UIView *buttonListView;
@property (weak, nonatomic) IBOutlet UIButton *firstButton;

@end

@implementation ViewController

#pragma mark 懒加载
-(NSArray *)dishList{
    if (_dishList==nil) {
        _dishList=[[NSArray alloc]init];
    }
    return _dishList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
     [self showTableView:self.firstButton];
    [self loadTableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showTableView:(UIButton *)sender {
    
    NSDictionary *param=@{
                          @"class":[NSString stringWithFormat:@"%ld",sender.tag-10]
                          };
    AFHTTPSessionManager *manage=[AFHTTPSessionManager manager];
    [manage GET:MenuURL parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.dishList=[DishInfo dishInfoSet:responseObject];
        [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error);
    }];
    [self changeButtonStatus:sender];
}

-(void)changeButtonStatus:(UIButton*)sender{
    for (UIButton *button in self.buttonListView.subviews) {
        button.selected=NO;
    }
    sender.selected=YES;
}



#pragma mark 加载tableView
-(void)loadTableView{
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView registerNib:[UINib nibWithNibName:@"DishViewCell" bundle:nil] forCellReuseIdentifier:@"dishView"];
    self.tableView.rowHeight=200;
    UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg"]];
    self.tableView.backgroundView=image;
    self.orderNum.backgroundColor=[UIColor redColor];
    self.orderNum.layer.masksToBounds = YES;
    self.orderNum.layer.cornerRadius = self.orderNum.frame.size.width/2;
    
    
}

#pragma mark 实现TableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dishList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DishViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"dishView" forIndexPath:indexPath];
    if (!cell) {
        cell=[[DishViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dishView"];
    }
    cell.delegate=self;
    DishInfo *dishInfo=self.dishList[indexPath.row];
    //给已点菜品赋值
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSArray *array=[ud objectForKey:@"dishes"];
    for (NSDictionary *dic in array) {
        if ([[dic objectForKey:@"id"]isEqualToString:dishInfo.dishNo]) {
        dishInfo.dishMany=[dic objectForKey:@"manynum"];
        }
             }
    
    
    [cell dishViewSetInfo:dishInfo];
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

#pragma mark cell的代理方法
-(void)dishViewCellReloadOrder:(NSArray *)orderList{
    NSInteger num=0;
    for (NSDictionary *dict in orderList) {
        NSString *numString=[dict objectForKey:@"manynum"];
        num+=[numString intValue];
    }
    self.orderNum.text=[NSString stringWithFormat:@"%ld",num];
    
    [self.tableView reloadData];

}
-(void)dishViewCellShowDetail:(NSString *)dishNO{
    DishDetailViewController *view=[[DishDetailViewController alloc]init];
    view.dishNo=dishNO;
    STPopupController *detailView=[[STPopupController alloc]initWithRootViewController:view];
    detailView.containerView.layer.cornerRadius = 6;
    detailView.transitionStyle = STPopupTransitionStyleFade;
    [detailView presentInViewController:self];

}

#pragma mark 跳转购物车

- (IBAction)showOrderView {
    
    OrderViewController * view = [[OrderViewController alloc]init];

    [self presentViewController:view animated:YES completion:nil];
    
}



@end
