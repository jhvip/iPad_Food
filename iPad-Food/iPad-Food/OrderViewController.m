//
//  OrderViewController.m
//  iPad-Food
//
//  Created by 蒋豪 on 16/4/1.
//  Copyright © 2016年 wpx. All rights reserved.
//

#import "OrderViewController.h"
#import "orderViewCell.h"
#import "AFNetworking.h"
#import "DishDetailViewController.h"
#import "STPopup.h"
#import "MakeTagView.h"
#import "PlaceOrderViewController.h"
@interface OrderViewController ()<UITableViewDataSource,UITableViewDelegate,orderViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *orderList;

@property (weak, nonatomic) IBOutlet UILabel *dishNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *acountMoneyLabel;


@property (weak, nonatomic) IBOutlet UIButton *dishImage;

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
    [self loadInfo];
    [self loadTableView];
    if (self.orderList.count==0) {
        self.tableView.sectionFooterHeight=0;
    }
    
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
    
    self.acountMoneyLabel.text=[self sumMoney];
    //设置section行高
    self.tableView.sectionHeaderHeight=60;
    self.tableView.sectionFooterHeight=80;
    UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg"]];
    self.tableView.backgroundView=image;

}


#pragma mark 实现TableView代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}
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
    
    
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"确定删除" message:@"确定删除所选的菜单吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cacelButton=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *makeButton=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        for (NSDictionary *dict in self.orderList) {
            NSString *dish_no=[dict objectForKey:@"id"];
            if ([dish_no isEqualToString:dishNO]) {
                
                [self.orderList removeObject:dict];
                if (self.orderList.count==0) {
                    self.tableView.sectionFooterHeight=0;
                }
               // [self.tableView reloadData];
                [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            }
        }
        self.acountMoneyLabel.text=[self sumMoney];
        
        
    }];
    [alert addAction:cacelButton];
    [alert addAction:makeButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
    
}

-(void)orderViewChangeInfo:(NSString *)dishNo withNum:(NSString *)num{
    for (NSDictionary *dict in self.orderList) {
        NSString *dish_no=[dict objectForKey:@"id"];
        if ([dish_no isEqualToString:dishNo]) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:dict];
            [dic setValue:num forKey:@"manynum"];
            [self.orderList replaceObjectAtIndex:[self.orderList indexOfObject:dict] withObject:dic];
            break;
        }
    }
    self.acountMoneyLabel.text=[self sumMoney];
    
}

-(void)orderViewMakeTag:(NSDictionary *)dishInfo{
    MakeTagView *view=[[MakeTagView alloc]init];
    view.dishInfo=dishInfo;
    STPopupController *makeTagView=[[STPopupController alloc]initWithRootViewController:view];
    makeTagView.containerView.layer.cornerRadius = 6;
    makeTagView.transitionStyle = STPopupTransitionStyleFade;
    makeTagView.navigationBarHidden=YES;
    [makeTagView presentInViewController:self];

}


#pragma mark 保存信息到列表
-(void)saveInfo{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setObject:self.orderList forKey:@"dishes"];
}
-(void)loadInfo{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    self.orderList=[NSMutableArray arrayWithArray:[ud objectForKey:@"dishes"]];
}

#pragma mark tableView 代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dishInfo=self.orderList[indexPath.row];
    self.dishNoLabel.text=[dishInfo objectForKey:@"id"];
    
    NSDictionary *param=@{@"dish_no":self.dishNoLabel.text,
                          };
    AFHTTPSessionManager *manage=[AFHTTPSessionManager manager];
    [manage GET:DetailURL parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"success,%@",responseObject);
        
        NSString *url=[NSString stringWithFormat:@"http://%@/image/%@",ip,[responseObject objectForKey:@"dish_pic"]];
        NSData *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        [self.dishImage setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error);
    }];
    
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view =[[[NSBundle mainBundle]loadNibNamed:@"HeadView" owner:nil options:nil]lastObject];
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view =[[[NSBundle mainBundle]loadNibNamed:@"FootView" owner:nil options:nil]lastObject];
    return view;
}
#pragma mark 清空菜单
- (IBAction)clearList {
    
    if (self.orderList.count==0) {
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"清空失败" message:@"您的当前菜单为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cacelButton=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *makeButton=[UIAlertAction actionWithTitle:@"去点菜" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:cacelButton];
        [alert addAction:makeButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
        
    }else{
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"确定清空" message:@"确定清空所有的菜单吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cacelButton=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *makeButton=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.orderList removeAllObjects];
            self.acountMoneyLabel.text=0;
            [self saveInfo];
            self.tableView.sectionFooterHeight=0;
            [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }];
        [alert addAction:cacelButton];
        [alert addAction:makeButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }

}

#pragma Mark 显示菜单详情

- (IBAction)showDetail:(id)sender {
    DishDetailViewController *view=[[DishDetailViewController alloc]init];
    view.dishNo=self.dishNoLabel.text;
    STPopupController *detailView=[[STPopupController alloc]initWithRootViewController:view];
    detailView.containerView.layer.cornerRadius = 6;
    detailView.transitionStyle = STPopupTransitionStyleFade;
    [detailView presentInViewController:self];
    
}

#pragma mark 加载口味设置
-(void)viewWillAppear:(BOOL)animated{
    NSNotificationCenter *notification= [NSNotificationCenter defaultCenter];
    [notification addObserver:self
           selector:@selector(setTag:)
               name:@"tagInfo"
             object:nil];
    
}

-(void)setTag:(NSNotification*)sender{
    NSDictionary *tagInfo=[sender object];
    NSString *dishNo=[tagInfo objectForKey:@"id"];
    for (NSDictionary *dic in self.orderList) {
        if ([[dic objectForKey:@"id"]isEqualToString:dishNo]) {
            [self.orderList replaceObjectAtIndex:[self.orderList indexOfObject:dic] withObject:tagInfo];
            break;
        }
    }
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (IBAction)placeOrder:(UIButton *)sender {
    PlaceOrderViewController *view=[[PlaceOrderViewController alloc]init];
    view.orderList=self.orderList;
    STPopupController *placeOrderView=[[STPopupController alloc]initWithRootViewController:view];
    placeOrderView.containerView.layer.cornerRadius = 6;
    placeOrderView.transitionStyle = STPopupTransitionStyleFade;
    placeOrderView.navigationBarHidden=YES;
    [placeOrderView presentInViewController:self];
    
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
