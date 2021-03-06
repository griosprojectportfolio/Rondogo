//
//  AppApi.h
//  Rondogo
//
//  Created by GrepRuby3 on 14/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworkActivityIndicatorManager.h"

@interface AppApi : AFHTTPRequestOperationManager

@property (nonatomic, retain) NSOperationQueue *downloadQueue;

+ (AppApi *)sharedClient ;
+ (AppApi *)sharedAuthorizedClient;
- (id)initWithBaseURL:(NSURL *)url;


- (AFHTTPRequestOperation *)loginUser:(NSDictionary *)aParams
                                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)signUpUser:(NSDictionary *)aParams
                              success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                              failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)updateUser:(NSDictionary *)aParams
                               success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                               failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)forgotPassword:(NSDictionary *)aParams
                                   success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                   failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)signOutUser:(NSDictionary *)aParams
                                success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)getAllObjects:(NSDictionary *)aParams
                                   success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                   failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;


- (AFHTTPRequestOperation *)uploadMediaWithBase64String:(NSDictionary *)aParams
                                                success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                                failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)getAllCategories:(NSDictionary *)aParams
                                     success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                     failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)getAllSubCategories:(NSDictionary *)aParams
                                        success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                        failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (void)downloadMediaData:(NSDictionary *)aParams
                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (NSURL *)getDocumentDirectoryFileURL:(NSDictionary *)aParams ;
- (BOOL)isMediaFileExistInDocumentDirectory:(NSDictionary *)aParams;
- (UIImage*)getImageFromDocumentDirectoryFileURL:(NSDictionary *)aParams;
-(UIImage *)generateThumbImage:(NSDictionary *)aParams;

@end
