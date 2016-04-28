//
//  MyOrderViewController.m
//  iPad-Food
//
//  Created by 吴鹏先 on 16/4/12.
//  Copyright © 2016年 wpx. All rights reserved.
//

#import "MyOrderViewController.h"
#import "STPopup.h"
#import "MyOrderCell.h"
#import "AFNetworking.h"
#import "MyOrderModel.h"
#import "OrderdetailViewController.h"
@interface MyOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *orderInfoList;

@end

@implementation MyOrderViewController

-(NSMutableArray *)orderInfoList{
    if (_orderInfoList==nil) {
        _orderInfoList=[NSMutableArray array];
    }
    return _orderInfoList;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.contentSizeInPopup = CGSizeMake(0,0);
        self.landscapeContentSizeInPopup = CGSizeMake(550, 650);
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [self searchOrder];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.rowHeight=80;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyOrderCell" bundle:nil] forCellReuseIdentifier:@"MyOrderCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyOrderCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MyOrderCell" forIndexPath:indexPath];
    if (!cell) {
        cell=[[MyOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyOrderCell"];
    }
    [cell setMyOrderCell:self.orderInfoList[indexPath.row]];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderInfoList.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOrderCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    
    OrderdetailViewController *view=[[OrderdetailViewController alloc]init];
    view.orderInfo=cell.orderInfo;
    [self.popupController pushViewController:view animated:YES];
    
}


-(void)searchOrder{
    //清楚之前的数据
    [self.orderInfoList removeAllObjects];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.myOrderList options:NSJSONWritingPrettyPrinted error:&error];//此处data参数是我上面提到的key为"data"的数组
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *param=@{@"orderList":jsonString,
                          };
    AFHTTPSessionManager *manage=[AFHTTPSessionManager manager];
    [manage POST:searchOrderURL parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *list=responseObject;
        for (NSDictionary *dic in list) {
            MyOrderModel *orderInfo=[[MyOrderModel alloc]init];
            orderInfo.orderMoney=[dic objectForKey:@"menu_money"];
            orderInfo.orderNum=[dic objectForKey:@"menu_num"];
            orderInfo.orderServed=[dic objectForKey:@"served"];
            orderInfo.orderTime=[dic objectForKey:@"menutime"];
            [self.orderInfoList insertObject:orderInfo atIndex:0];
        }
        [self.tableView reloadData];
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
