//
//  RestaurantViewController.m
//  iPad-Food
//
//  Created by 吴鹏先 on 16/4/20.
//  Copyright © 2016年 wpx. All rights reserved.
//

#import "RestaurantViewController.h"
#import "RequestUrl.h"
#import "ViewController.h"
@interface RestaurantViewController ()

@end

@implementation RestaurantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadWebView];
}

-(void)loadWebView{
    
    CGRect bounds = [[UIScreen mainScreen]applicationFrame];
    UIWebView* webView = [[UIWebView alloc]initWithFrame:bounds];
    
    webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    
    [self.view addSubview:webView];

    NSURL* url = [NSURL URLWithString:RestaurantURL];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [webView loadRequest:request];//加载
    
    
    UIButton *startButton=[[UIButton alloc]initWithFrame:CGRectMake(bounds.size.width-180, 40, 120, 60)];
    
    startButton.backgroundColor=[UIColor yellowColor];
    [startButton setTitle:@"开始点餐" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [startButton bringSubviewToFront:webView];
    [webView addSubview:startButton];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)start{
    ViewController * main = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = main;
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
