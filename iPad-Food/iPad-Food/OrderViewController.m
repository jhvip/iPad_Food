//
//  OrderViewController.m
//  iPad-Food
//
//  Created by 蒋豪 on 16/4/1.
//  Copyright © 2016年 wpx. All rights reserved.
//

#import "OrderViewController.h"
#import "orderViewCell.h"
@interface OrderViewController ()<UITableViewDataSource,UITableViewDelegate,orderViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *orderList;

@end

@implementation OrderViewController

-(NSMutableArray *)orderList{
    if (_orderList==nil) {
        _orderList=[NSMutableArray array];
    }
    return _orderList;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];

    self.orderList=[NSMutableArray arrayWithArray:[ud objectForKey:@"dishes"]];
    [self loadTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backIndex:(id)sender {
    [self saveInfo];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark 加载tableView
-(void)loadTableView{
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView registerNib:[UINib nibWithNibName:@"orderViewCell" bundle:nil] forCellReuseIdentifier:@"orderView"];
    self.tableView.rowHeight=80;
}


#pragma mark 实现TableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    orderViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"orderView" forIndexPath:indexPath];
    if (!cell) {
        cell=[[orderViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dishView"];
    }
    cell.delegate=self;
    [cell orderViewSetInfo:self.orderList[indexPath.row]];
    return cell;
}

#pragma mark cell的代理方法
-(void)orderViewDeleteInfo:(NSString *)dishNO{
    for (NSDictionary *dict in self.orderList) {
        NSString *dish_no=[dict objectForKey:@"id"];
        if ([dish_no isEqualToString:dishNO]) {
            
            [self.orderList removeObject:dict];
            [self.tableView reloadData];
            return;
        }
    }


}

-(void)saveInfo{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:self.orderList forKey:@"dishes"];
    
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
