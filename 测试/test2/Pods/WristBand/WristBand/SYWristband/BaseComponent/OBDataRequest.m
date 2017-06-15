//
//  OBDataRequest.m
//  UCCertificate
//
//  Created by obally on 16/3/14.
//  Copyright © 2016年 ___obally___. All rights reserved.
//

#import "OBDataRequest.h"
//#import "SYLoginViewController.h"

@implementation OBDataRequest
+ (void)requestWithURL:(NSString *_Nonnull)urlstring
                params:(NSMutableDictionary *_Nullable)params
            httpMethod:(NSString *_Nonnull)httpMethod
         progressBlock:(ProgressBlock _Nonnull)progressBlock
       completionblock:(CompletionLoadHandle _Nonnull)completionBlock
           failedBlock:(FailedLoadBlock _Nonnull)failedBlock
{
    if (params == nil) {
        params = [NSMutableDictionary dictionary];
    }
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if ([httpMethod isEqualToString:@"GET"]) {
        //发送GET请求
        [sessionManager GET:urlstring parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            NSLog(@"%lld", downloadProgress.totalUnitCount);
            if (progressBlock != nil) {
                progressBlock(downloadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@", responseObject);
            id JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功JSON:%@", JSON);
            
            if (completionBlock != nil) {
                completionBlock(JSON);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            if (failedBlock != nil) {
                failedBlock([error localizedDescription]);
            }
        }];
        
    }else if ([httpMethod isEqualToString:@"POST"]) {
        //发送POST请求
        BOOL isFile = NO;
        for (NSString *key in params) {
            id value = params[key];
            if (value != nil) {
                if ([value isKindOfClass:[NSData class]]) {
                    isFile = YES;
                    break;
                }
            }
        }
        if (!isFile) {
            NSString *paramsStr = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
            NSLog(@"请求地址：  %@, 请求参数： %@\n", urlstring, paramsStr);
            //如果参数中没有文件
            [sessionManager POST:urlstring parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                if (progressBlock != nil) {
                    progressBlock(uploadProgress);
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //                NSLog(@"请求成功:%@", responseObject);
                
                NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                //                NSLog(@"请求成功JSON:%@", JSON);
                NSLog(@"请求成功:%@,JSON:  %@",task.originalRequest.URL.absoluteString, [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
                //统一拦截 如果token过期
                NSString *number = [JSON[@"resultCode"] stringValue];
                if ([number isEqualToString:@"-1"]) {
                    //重新登录
                    [[SYUserDataManager manager]removeUserLoginData];
//                    SYLoginViewController *loginVC = [[SYLoginViewController alloc]init];
//                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
//                    [UIApplication sharedApplication].delegate.window.rootViewController = nav;
                    return ;
                }
                if (completionBlock != nil) {
                    completionBlock(JSON);
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failedBlock != nil) {
                    failedBlock([error localizedDescription]);
                }
                
            }];
        } else {
            //如果参数中带有参数
            [sessionManager POST:urlstring parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                for (NSString *key in params) {
                    id value = params[key];
                    if ([value isKindOfClass:[NSData class]]) {
                        //将文件添加到formData中
                        [formData appendPartWithFileData:value
                                                    name:key
                                                fileName:@".jpg"
                                                mimeType:@"image/jpeg"];
                    }
                }
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                if (progressBlock != nil) {
                    progressBlock(uploadProgress);
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//                NSLog(@"请求成功JSON:%@", JSON);
                NSLog(@"请求成功:%@,JSON:  %@",task.originalRequest.URL.absoluteString, JSON);
                //统一拦截 如果token过期
                NSString *number = [JSON[@"resultCode"] stringValue];
                if ([number isEqualToString:@"-1"]) {
                    //重新登录
                    [[SYUserDataManager manager]removeUserLoginData];
//                    SYLoginViewController *loginVC = [[SYLoginViewController alloc]init];
//                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
//                    [UIApplication sharedApplication].delegate.window.rootViewController = nav;
                    return ;
                }
                if (completionBlock != nil) {
                    completionBlock(JSON);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failedBlock != nil) {
                    failedBlock([error localizedDescription]);
                }
                
            }];
        }
    }
}


@end
