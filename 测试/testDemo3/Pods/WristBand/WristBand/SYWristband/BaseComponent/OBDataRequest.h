//
//  OBDataRequest.h
//  UCCertificate
//
//  Created by obally on 16/3/14.
//  Copyright © 2016年 ___obally___. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^CompletionLoadHandle)(id _Nonnull result);
typedef void(^FailedLoadBlock )(id _Nonnull error);
typedef void (^ProgressBlock)(NSProgress * _Nonnull downloadProgress);
@interface OBDataRequest : NSObject

+ (void)requestWithURL:(NSString *_Nonnull)urlstring
                params:(NSMutableDictionary *_Nullable)params
            httpMethod:(NSString *_Nonnull)httpMethod
         progressBlock:(ProgressBlock _Nonnull)progressBlock
       completionblock:(CompletionLoadHandle _Nonnull)completionBlock
           failedBlock:(FailedLoadBlock _Nonnull)failedBlock;

@end
