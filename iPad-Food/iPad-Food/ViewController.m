//
//  ViewController.m
//  iPad-Food
//
//  Created by 蒋豪 on 16/3/29.
//  Copyright © 2016年 wpx. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showTableView:(UIButton *)sender {
    
    NSDictionary *param=@{
                          @"class":[NSString stringWithFormat:@"%ld",sender.tag]
                          };
    AFHTTPSessionManager *manage=[AFHTTPSessionManager manager];
    NSLog(@"%@",MenuURL);
    [manage GET:MenuURL parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success,%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error);
    }];
}


@end
