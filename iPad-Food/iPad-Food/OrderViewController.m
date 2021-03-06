//
//  OrderViewController.m
//  iPad-Food
//
//  Created by 吴鹏先 on 16/4/1.
//  Copyright © 2016年 wpx. All rights reserved.
//

#import "OrderViewController.h"
#import "orderViewCell.h"
#import "AFNetworking.h"
#import "DishDetailViewController.h"
#import "STPopup.h"
#import "MakeTagView.h"
#import "PlaceOrderViewController.h"
#import "DeskViewController.h"
#import "MyOrderViewController.h"
#import "MyOrderModel.h"
@interface OrderViewController ()<UITableViewDataSource,UITableViewDelegate,orderViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *orderList;

@property (weak, nonatomic) IBOutlet UILabel *dishNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *acountMoneyLabel;


@property (weak, nonatomic) IBOutlet UIButton *dishImage;
@property (weak, nonatomic) IBOutlet UILabel *deskNumLabel;

@property (nonatomic,strong)NSMutableArray *historyOrder;

@end

@implementation OrderViewController

#pragma mark 懒加载
-(NSMutableArray *)orderList{
    if (_orderList==nil) {
        _orderList=[NSMutableArray array];
    }
    return _orderList;

}
-(NSMutableArray *)historyOrder{
    if (_historyOrder==nil) {
        _historyOrder=[NSMutableArray array];
    }
    return _historyOrder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadTableView];
    
}
#pragma mark 口味设置信息
-(void)viewWillAppear:(BOOL)animated{
    NSNotificationCenter *notification= [NSNotificationCenter defaultCenter];
    [notification addObserver:self
                     selector:@selector(setTag:)
                         name:@"tagInfo"
                       object:nil];
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    self.deskNumLabel.text=[ud objectForKey:@"deskNum"];
    [self.orderList removeAllObjects];
    
    [self loadInfo];
    
    [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    if (self.orderList.count==0) {
        self.tableView.sectionFooterHeight=0;
    }
    [self loadHistoryOrder];
    self.acountMoneyLabel.text=[self sumMoney];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 返回首页
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
    
    //设置section行高
    self.tableView.sectionHeaderHeight=60;
    self.tableView.sectionFooterHeight=80;
    UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg"]];
    self.tableView.backgroundView=image;

}


#pragma mark 实现TableView代理方法
//返回tableView行高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}
//返回tableView列数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//返回tableView的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderList.count;
}
//返回tableView的Cell
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
#pragma Mark 代理方法
//改变菜品数量
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
//菜品口味设置
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


-(void)setTag:(NSNotification*)sender{
    NSDictionary *tagInfo=[sender object];
    NSString *dishNo=[tagInfo objectForKey:@"id"];
    for (NSDictionary *dic in self.orderList) {
        if ([[dic objectForKey:@"id"]isEqualToString:dishNo]) {
            [self.orderList replaceObjectAtIndex:[self.orderList indexOfObject:dic] withObject:tagInfo];
            [self saveInfo];
            break;
        }
    }
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 下订单
- (IBAction)placeOrder:(UIButton *)sender {
    
    if (self.deskNumLabel.text==nil) {
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"下单失败" message:@"您还没有选择桌号" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cacelButton=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *makeButton=[UIAlertAction actionWithTitle:@"选桌号" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self selectDesk:[[UIButton alloc]init]];
        }];
        [alert addAction:cacelButton];
        [alert addAction:makeButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    if (self.orderList.count==0) {
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"下单失败" message:@"您的当前菜单为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cacelButton=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *makeButton=[UIAlertAction actionWithTitle:@"去点菜" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:cacelButton];
        [alert addAction:makeButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        PlaceOrderViewController *view=[[PlaceOrderViewController alloc]init];
        view.orderList=self.orderList;
        STPopupController *placeOrderView=[[STPopupController alloc]initWithRootViewController:view];
        placeOrderView.containerView.layer.cornerRadius = 6;
        placeOrderView.transitionStyle = STPopupTransitionStyleFade;
        placeOrderView.navigationBarHidden=YES;
        [placeOrderView presentInViewController:self];
    }
    
}
#pragma mark 选择桌号
- (IBAction)selectDesk:(UIButton *)sender {
    DeskViewController *view=[[DeskViewController alloc]init];
    
    STPopupController *DeskView=[[STPopupController alloc]initWithRootViewController:view];
    DeskView.containerView.layer.cornerRadius = 6;
    DeskView.transitionStyle = STPopupTransitionStyleFade;
    DeskView.navigationBarHidden=YES;
    [DeskView presentInViewController:self];
}

//我的订单
- (IBAction)showOrder:(id)sender {
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSArray *orderList=[ud objectForKey:@"orderList"];
    
    
    if (orderList.count==0) {
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"查看失败" message:@"您的当前菜单为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cacelButton=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *makeButton=[UIAlertAction actionWithTitle:@"去点菜" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:cacelButton];
        [alert addAction:makeButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        MyOrderViewController *view=[[MyOrderViewController alloc]init];
        view.myOrderList=orderList;
        STPopupController *orderView=[[STPopupController alloc]initWithRootViewController:view];
        orderView.containerView.layer.cornerRadius = 6;
        orderView.transitionStyle = STPopupTransitionStyleFade;
        orderView.navigationBarHidden=YES;
        [orderView presentInViewController:self];
    }
    
}

#pragma mark 退单
- (IBAction)cancel:(id)sender {
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSArray *orderList=[ud objectForKey:@"orderList"];
    
    
    
    if (orderList.count==0) {
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"退单失败" message:@"您的当前菜单为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cacelButton=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *makeButton=[UIAlertAction actionWithTitle:@"去点菜" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:cacelButton];
        [alert addAction:makeButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        BOOL status=NO;
        int i=0;
        for (MyOrderModel *model in self.historyOrder) {
            if ([model.orderServed isEqualToString:@"0"]) {
                status=YES;
                break;
            }
            i++;
        }
        if (!status) {
            UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"退单失败" message:@"你没有未支付的订单" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cacelButton=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            UIAlertAction *makeButton=[UIAlertAction actionWithTitle:@"去点菜" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:cacelButton];
            [alert addAction:makeButton];
            
            [self presentViewController:alert animated:YES completion:nil];

        }else{
            UIAlertController *alert =[UIAlertController alertControllerWithTitle:nil message:@"是否确认退单！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cacelButton=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            UIAlertAction *makeButton=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self.historyOrder removeObjectAtIndex:i];
                NSMutableArray *temp=[NSMutableArray array];
                for (MyOrderModel *model in self.historyOrder) {
                    [temp addObject:model.orderNum];
                }
                [ud setObject:temp forKey:@"orderList"];
                
                [NSThread sleepForTimeInterval:1];
                UIAlertController *alert1=[UIAlertController alertControllerWithTitle:nil message:@"退单成功！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cacelButton1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alert1 addAction:cacelButton1];
                [self presentViewController:alert1 animated:YES completion:nil];
                
            }];
            [alert addAction:cacelButton];
            [alert addAction:makeButton];
            
            [self presentViewController:alert animated:YES completion:nil];

        
        }
        
    }
    
    
}


-(void)loadHistoryOrder{
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSArray *temp=[ud objectForKey:@"orderList"];
    NSMutableArray *orderList=[NSMutableArray arrayWithArray:temp];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:orderList options:NSJSONWritingPrettyPrinted error:&error];//此处data参数是我上面提到的key为"data"的数组
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *param=@{@"orderList":jsonString,
                          };
    AFHTTPSessionManager *manage=[AFHTTPSessionManager manager];
    [manage POST:searchOrderURL parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *list=responseObject;
        [self.historyOrder removeAllObjects];
        for (NSDictionary *dic in list) {
            MyOrderModel *orderInfo=[[MyOrderModel alloc]init];
            orderInfo.orderMoney=[dic objectForKey:@"menu_money"];
            orderInfo.orderNum=[dic objectForKey:@"menu_num"];
            orderInfo.orderServed=[dic objectForKey:@"served"];
            orderInfo.orderTime=[dic objectForKey:@"menutime"];
            [self.historyOrder addObject:orderInfo];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
    


}

- (IBAction)cleanOrder:(id)sender {
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"清除订单" message:@"是否确认清除所有订单！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cacelButton=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *makeButton=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
        NSMutableArray *temp=[NSMutableArray array];
        [ud setObject:temp forKey:@"orderList"];
        
        [NSThread sleepForTimeInterval:1];
        UIAlertController *alert1=[UIAlertController alertControllerWithTitle:nil message:@"清除成功！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cacelButton1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert1 addAction:cacelButton1];
        [self presentViewController:alert1 animated:YES completion:nil];
        
    }];
    [alert addAction:cacelButton];
    [alert addAction:makeButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
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
