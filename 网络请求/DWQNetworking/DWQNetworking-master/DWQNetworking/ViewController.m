//
//  ViewController.m
//  DWQNetworking
//
//  Created by 杜文全 on 16/9/28.
//  Copyright © 2016年 杜文全. All rights reserved.
//   杜文全版权所有》--->如果问题请联系 439878592@qq.com
//

#import "ViewController.h"
#import "DWQNetworking.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     DWQNetworking文件夹包含了AFNetworking的3.1.0版本，已经适配https；
     包含了多年工作封装的分类，扩展。
     
    使用方法，将DWQNetworking文件夹拖入工程中然后[在pch文件中引入头文件DWQNetworking.h]
    采用单例模式
     1.Get请求
    [DWQNetworking sharedDWQNetworking] GET
     2.Post请求
    [DWQNetworking sharedDWQNetworking] POST
    
     具体使用方法请查看DWQNetworking.h的说明
     【注意】：
    一、 如果请求数据时候为PHP服务器，要求为json串的话，需要在DWQNetworking.m文件下所有封装的方法get或者post请求之前加上
     //声明传的是json对象
     manager.requestSerializer=[AFJSONRequestSerializer serializer];
     这段代码即可。
    二、如果上传头像需要form表单形式上传，且参数也作为form表单形式，需要在封装的上传图片的方法中传入相应的参数值。
     
     [formData appendPartWithFileData:data name:picName fileName:fileName mimeType:@"image/jpeg"];
     
     //【上传图片时候加的参数在下边这段代码中写】
     
     NSData *data1=[mid dataUsingEncoding:NSUTF8StringEncoding];
     
     [formData appendPartWithFormData:data1 name:@"member_id"];
     其中：
     mid 是修改方法传过来的参数值
     member_id是参数的key
    */


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
