//
//  LoginViewController.m
//  iPad-Food
//
//  Created by 吴鹏先 on 16/3/29.
//  Copyright © 2016年 wpx. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewController.h"
#import "RestaurantViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)showWebIndex {
    RestaurantViewController *view=[[RestaurantViewController alloc]init];
    
    [self presentViewController:view animated:YES completion:nil];
    
}


- (IBAction)showDishMian {
    
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
