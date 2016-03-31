//
//  ViewController.m
//  iPad-Food
//
//  Created by 蒋豪 on 16/3/29.
//  Copyright © 2016年 wpx. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "DishInfo.h"
#import "DishViewCell.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,DishViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSArray *dishList;

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
    
    [self loadTableView];
    
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
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error);
    }];
}


#pragma mark 加载tableView
-(void)loadTableView{
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView registerNib:[UINib nibWithNibName:@"DishViewCell" bundle:nil] forCellReuseIdentifier:@"dishView"];
    self.tableView.rowHeight=200;
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
    [cell dishViewSetInfo:self.dishList[indexPath.row]];
    return cell;
}

#pragma mark cell的代理方法
-(void)dishViewCellReloadOrder:(NSArray *)orderList{
    
    [self.tableView reloadData];
}


@end
