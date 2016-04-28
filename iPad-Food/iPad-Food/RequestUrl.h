//
//  RequestUrl.h
//  iPad-Food
//
//  Created by 吴鹏先 on 16/3/31.
//  Copyright © 2016年 wpx. All rights reserved.
//

#ifndef RequestUrl_h
#define RequestUrl_h

//内网测试IP
//#define ip @"127.0.0.1:8080/iPad_Server"
//外网IP
#define ip @"115.159.184.122:8080/iPad_Server"

//菜单URL
#define MenuURL [NSString stringWithFormat:@"http://%@/DishControlServlet",ip]
//菜单详情页
#define DetailURL [NSString stringWithFormat:@"http://%@/DishDetailServlet",ip]

//提交订单
#define SubmitMenuURL [NSString stringWithFormat:@"http://%@/DishMenuServlet",ip]
//查看当前订单
#define searchOrderURL [NSString stringWithFormat:@"http://%@/DishSearchOrder",ip]
//查看菜单详情
#define OrderDetailURL [NSString stringWithFormat:@"http://%@/OrderDetailServlet",ip]
//支付订单
#define PayMoneyURL [NSString stringWithFormat:@"http://%@/PayOrderMoneyServlet",ip]
//官网地址
#define RestaurantURL [NSString stringWithFormat:@"http://%@/restaurant.html",ip]

#endif /* RequestUrl_h */
