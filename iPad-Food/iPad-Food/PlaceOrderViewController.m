//
//  PlaceOrderViewController.m
//  iPad-Food
//
//  Created by 蒋豪 on 16/4/7.
//  Copyright © 2016年 wpx. All rights reserved.
//

#import "PlaceOrderViewController.h"
#import "STPopup.h"
#import "PlaceOrderViewCell.h"
@interface PlaceOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSString *sumMoney;
@end

@implementation PlaceOrderViewController

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
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.rowHeight=60;
    [self.tableView registerNib:[UINib nibWithNibName:@"PlaceOrderViewCell" bundle:nil] forCellReuseIdentifier:@"placeOrderView"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PlaceOrderViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"placeOrderView" forIndexPath:indexPath];
    if (!cell) {
        cell=[[PlaceOrderViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"placeOrderView"];
    }
    [cell placeOrderViewSetInfo:self.orderList[indexPath.row]];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderList.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView=[[[NSBundle mainBundle]loadNibNamed:@"PlaceOrderFootView" owner:self options:nil]lastObject];
    self.sumMoney=[self sumMoney];
    for (UILabel *sumMoney in footView.subviews) {
        sumMoney.text=[NSString stringWithFormat:@"总计:%@元",self.sumMoney];
    }
    return footView;
}

-(NSString*)sumMoney{
    NSInteger sum=0;
    for (NSDictionary *dict in self.orderList) {
        NSInteger money=[[dict objectForKey:@"acountnum"] intValue];
        NSInteger num=[[dict objectForKey:@"manynum"] intValue];
        sum+=money*num;
    }
    return [NSString stringWithFormat:@"%ld",sum];
}

- (IBAction)ensureOrder:(id)sender {
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
