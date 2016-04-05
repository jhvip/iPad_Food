//
//  RequestUrl.h
//  iPad-Food
//
//  Created by 蒋豪 on 16/3/31.
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


#endif /* RequestUrl_h */
