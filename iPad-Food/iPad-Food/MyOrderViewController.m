//
//  MyOrderViewController.m
//  iPad-Food
//
//  Created by 蒋豪 on 16/4/12.
//  Copyright © 2016年 wpx. All rights reserved.
//

#import "MyOrderViewController.h"
#import "STPopup.h"
#import "MyOrderCell.h"
@interface MyOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MyOrderViewController

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
    [cell setMyOrderCell:self.myOrderList[indexPath.row]];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myOrderList.count;
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
