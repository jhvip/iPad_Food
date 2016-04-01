//
//  DishDetailViewController.m
//  iPad-Food
//
//  Created by 蒋豪 on 16/3/31.
//  Copyright © 2016年 wpx. All rights reserved.
//

#import "DishDetailViewController.h"
#import "STPopup.h"
#import "AFNetworking.h"
@interface DishDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@end

@implementation DishDetailViewController

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{

    NSDictionary *param=@{@"dish_no":self.dishNo,
                          };
    AFHTTPSessionManager *manage=[AFHTTPSessionManager manager];
    [manage GET:DetailURL parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success,%@",responseObject);
        [self dishSetInfo:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error);
    }];
}



-(void)dishSetInfo:(NSDictionary*)dict{
    self.detailLabel.text=[dict objectForKey:@"dish_detail"];
    self.tagLabel.text=[dict objectForKey:@"dish_tag"];
    
    NSString *url=[NSString stringWithFormat:@"http://%@/image/%@",ip,[dict objectForKey:@"dish_pic"]];
    NSData *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    self.imageView.image=[UIImage imageWithData:imageData];
    self.title=[dict objectForKey:@"dish_name"];

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
