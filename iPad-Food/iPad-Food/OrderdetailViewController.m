//
//  OrderdetailViewController.m
//  iPad-Food
//
//  Created by 蒋豪 on 16/4/13.
//  Copyright © 2016年 wpx. All rights reserved.
//

#import "OrderdetailViewController.h"
#import "STPopup.h"
#import "OrderDetailCell.h"
#import "AFNetworking.h"
#import "MyOrderModel.h"
@interface OrderdetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (nonatomic,strong)NSMutableArray *detailInfoList;


@end

@implementation OrderdetailViewController
-(NSMutableArray *)detailInfoList{
    if (_detailInfoList==nil) {
        _detailInfoList=[NSMutableArray array];
    }
    return _detailInfoList;
}
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
    [self loadInfo];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.rowHeight=60;
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderDetailCell" bundle:nil] forCellReuseIdentifier:@"OrderDetailCell"];
    if (![self.orderInfo.orderServed isEqualToString:@"0"]) {
        self.payButton.backgroundColor=[UIColor grayColor];
        self.payButton.userInteractionEnabled=NO;
        [self.payButton setTitle:@"已支付" forState:UIControlStateNormal];
    }

}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderDetailCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OrderDetailCell" forIndexPath:indexPath];
    if (!cell) {
        cell=[[OrderDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderDetailCell"];
    }
    [cell setCellInfo:self.detailInfoList[indexPath.row] withOrderInfo:self.orderInfo];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.detailInfoList.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[[NSBundle mainBundle]loadNibNamed:@"OrderDetailHead" owner:self options:nil]lastObject];
    return view;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    [self.popupController popViewControllerAnimated:YES];
}

- (IBAction)payMoney:(id)sender {
}

-(void)loadInfo{
    NSDictionary *param=@{@"orderNum":self.orderInfo.orderNum,
                          };
    AFHTTPSessionManager *manage=[AFHTTPSessionManager manager];
    [manage POST:OrderDetailURL parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        self.detailInfoList=[NSMutableArray arrayWithArray:responseObject];
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
