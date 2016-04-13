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
#import "AFNetworking.h"
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
    if (self.orderList.count==0) {
        self.tableView.hidden=YES;
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
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确认下单" message:@"是否确认下单？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *canelButton=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *submitButton=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self submitOrder];
    }];
    [alert addAction:canelButton];
    [alert addAction:submitButton];
    [self presentViewController:alert animated:YES completion:nil];

    
    
}

-(void)submitOrder{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSString *tabel_no=[ud objectForKey:@"deskNum"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.orderList options:NSJSONWritingPrettyPrinted error:&error];//此处data参数是我上面提到的key为"data"的数组
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *param=@{@"table_no":tabel_no,
                          @"info":jsonString,
                          @"sumMoney":[self sumMoney],
                          };
    AFHTTPSessionManager *manage=[AFHTTPSessionManager manager];
    [manage POST:SubmitMenuURL parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"success"]) {
            self.orderList=@[];
            NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
            [ud setObject:nil forKey:@"dishes"];
            NSMutableArray *orderList=[NSMutableArray arrayWithArray:[ud objectForKey:@"orderList"]];
            [orderList addObject:[responseObject objectForKey:@"message"]];
            [ud setObject:orderList forKey:@"orderList"];
            
            [self.tableView reloadData];
            [self back:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
    
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
