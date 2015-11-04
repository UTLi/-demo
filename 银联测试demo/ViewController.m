//
//  ViewController.m
//  银联测试demo
//
//  Created by LP on 15/8/31.
//  Copyright (c) 2015年 LP. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "UPPayPlugin.h"

@interface ViewController ()<UPPayPluginDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
//不包含语音的支付方式只需要下列四部:
//1.把UpPay(银联)文件夹拉入工程.
//2.导入"UPPayPlugin.h"头文件
//3.遵循<UPPayPluginDelegate>代理方法
//4.在Build Settings下面的 Other Linker Flags 添加  -ObjC
//5:下面点击button的代码加入工程
- (IBAction)ClickPay:(id)sender {
   
    //点击按钮进行银联支付=========================================================================================
    //和公司服务器交互post,发送商品需要的参数(和公司服务器决定),返回(tn)"tn为银联生成的订单号"
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSDictionary *parameters = @{@"productName":@"MAC",@"productPrice":@"10000"};//此参数为需要传给公司服务器的商品参数
        NSString *url = @"";//POST接口
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@",responseObject);
            NSString *tn = [responseObject objectForKey:@"tn"];//公司服务器返回的tn
            if (tn != nil&& tn.length > 0) {
                //发送订单
                [UPPayPlugin startPay:tn mode:@"01" viewController:self delegate:self];//发送订单只需要两个参数@"tn"和"mode",tn由公司服务器返回,mode有两种@"01"为测试 ,@"00"为正式版本
            }else {
                UIAlertView *alter =  [[UIAlertView alloc]initWithTitle:@"网络连接失败" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alter show];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@",error);
        }];
    
    }

    
#pragma mark UPPayPluginResult--银联支付成功后回调
- (void)UPPayPluginResult:(NSString *)result
{
    NSString* msg = [NSString stringWithFormat:@"%@", result];//支付结果
    if ([msg isEqualToString:@"success"]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"支付成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else if ([msg isEqualToString:@"fail"]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"支付失败" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else if([msg isEqualToString:@"cancel"]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"支付已取消" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}

    


@end
