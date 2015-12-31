//
//  AppApi.m
//  Rondogo
//
//  Created by GrepRuby3 on 14/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "AppApi.h"

/* API Constants */
//static NSString * const kAppAPIBaseURLString = @"http://192.168.10.49:3000/api/v1";
//static NSString * const kAppMediaBaseURLString = @"http://192.168.10.49:3000";

static NSString * const kAppAPIBaseURLString = @"https://rondogo.herokuapp.com/api/v1";

@interface AppApi ()

@end

@implementation AppApi

/* API Clients */

+ (AppApi *)sharedClient {
    
    static AppApi * _sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AppApi alloc] initWithBaseURL:[NSURL URLWithString:kAppAPIBaseURLString]];
    });
    
    return [AppApi manager];
}

+ (AppApi *)sharedAuthorizedClient{
    return nil;
}

/* API Initialization */

-(id)initWithBaseURL:(NSURL *)url {
    [self initializeOperationQueueForDownload];
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    return self;
}

/* API Deallocation */

-(void)dealloc {
    
}

-(void)initializeOperationQueueForDownload{
    self.downloadQueue = [[NSOperationQueue alloc] init];
    self.downloadQueue.maxConcurrentOperationCount = 3;
    self.downloadQueue.name = @"com.rondogo.app.downloadQueue";
}

#pragma mark- User login method

- (AFHTTPRequestOperation *)loginUser:(NSDictionary *)aParams
                              success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                              failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@/sessions/login",kAppAPIBaseURLString];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    return [self POST:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        if(successBlock){
            @try {
                NSLog(@"Create Session (login) ");
                NSMutableArray *arrResponse = [[NSMutableArray alloc] init];
                [arrResponse addObject:[responseObject valueForKey:@"user"]];
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    [User entityFromArray:[NSArray arrayWithArray:arrResponse] inContext:localContext];
                }];
                successBlock(task, responseObject);
            }
            @catch (NSException *exception) {
                [self processExceptionBlock:task blockException:exception];
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
            [self processFailureBlock:task blockError:error];
            failureBlock(task, error);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
}

#pragma mark- User signup method

- (AFHTTPRequestOperation *)signUpUser:(NSDictionary *)aParams
                               success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                               failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] initWithDictionary:aParams];
    [dictParams removeObjectForKey:@"auth_token"];
    
    NSString *url = [NSString stringWithFormat:@"%@/registrations",kAppAPIBaseURLString];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    return [self POST:url parameters:dictParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        if(successBlock){
            @try {
                NSLog(@"registrations");
                NSMutableArray *arrResponse = [[NSMutableArray alloc] init];
                [arrResponse addObject:[responseObject valueForKey:@"user"]];
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    [User entityFromArray:[NSArray arrayWithArray:arrResponse] inContext:localContext];
                }];
                successBlock(task, responseObject);
            }
            @catch (NSException *exception) {
                [self processExceptionBlock:task blockException:exception];
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
            [self processFailureBlock:task blockError:error];
            failureBlock(task, error);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
}

#pragma mark- Update user information method

- (AFHTTPRequestOperation *)updateUser:(NSDictionary *)aParams
                               success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                               failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
    
    [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] initWithDictionary:aParams];
    [dictParams removeObjectForKey:@"auth_token"];
    
    NSString *url = [NSString stringWithFormat:@"%@/update",kAppAPIBaseURLString];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    return [self PATCH:url parameters:dictParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        if(successBlock){
            @try {
                NSLog(@"update");
                NSMutableArray *arrResponse = [[NSMutableArray alloc] init];
                [arrResponse addObject:[responseObject valueForKey:@"user"]];
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    [User entityFromArray:[NSArray arrayWithArray:arrResponse] inContext:localContext];
                }];
                successBlock(task, responseObject);
            }
            @catch (NSException *exception) {
                [self processExceptionBlock:task blockException:exception];
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
            [self processFailureBlock:task blockError:error];
            failureBlock(task, error);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
}


#pragma mark- Forgot password method

- (AFHTTPRequestOperation *)forgotPassword:(NSDictionary *)aParams
                                   success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                   failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@/forget_password",kAppAPIBaseURLString];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    return [self POST:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        if(successBlock){
            @try {
                NSLog(@"forget_password");
                successBlock(task, responseObject);
            }
            @catch (NSException *exception) {
                [self processExceptionBlock:task blockException:exception];
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
            [self processFailureBlock:task blockError:error];
            failureBlock(task, error);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
}

#pragma mark- User log out method

- (AFHTTPRequestOperation *)signOutUser:(NSDictionary *)aParams
                                success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
    
    [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
    NSString *url = [NSString stringWithFormat:@"%@/sessions/logout",kAppAPIBaseURLString];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    return [self DELETE:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        if(successBlock){
            @try {
                NSLog(@"User successfully logged out.");
                NSHTTPCookie *cookie;
                NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                for (cookie in [storage cookies]) {
                    [storage deleteCookie:cookie];
                }
                [self deleteAllEntityObjects];
                successBlock(task, responseObject);
            }
            @catch (NSException *exception) {
                [self processExceptionBlock:task blockException:exception];
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
            [self processFailureBlock:task blockError:error];
            failureBlock(task, error);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
}

#pragma mark - Fetch Categories and sub Categories

- (AFHTTPRequestOperation *)getAllCategories:(NSDictionary *)aParams
                                     success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                     failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *url = [NSString stringWithFormat:@"%@/categories",kAppAPIBaseURLString];
    
    return [self GET:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        if(successBlock){
            @try {
                NSMutableArray *arrResponse = [responseObject valueForKey:@"data"];
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    [Categories entityFromArray:arrResponse inContext:localContext];
                }];
                successBlock(task, responseObject);
            }
            @catch (NSException *exception) {
                [self processExceptionBlock:task blockException:exception];
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
            [self processFailureBlock:task blockError:error];
            failureBlock(task, error);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
}

- (AFHTTPRequestOperation *)getAllSubCategories:(NSDictionary *)aParams
                                        success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                        failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *url = [NSString stringWithFormat:@"%@/sub_categories",kAppAPIBaseURLString];
    
    return [self GET:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        if(successBlock){
            @try {
                NSMutableArray *arrResponse = [responseObject valueForKey:@"data"];
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    [SubCategories entityFromArray:arrResponse inContext:localContext];
                }];
                successBlock(task, responseObject);
            }
            @catch (NSException *exception) {
                [self processExceptionBlock:task blockException:exception];
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
            [self processFailureBlock:task blockError:error];
            failureBlock(task, error);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
}


#pragma mark- Media objects method

- (AFHTTPRequestOperation *)getAllObjects:(NSDictionary *)aParams
                                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *url = [NSString stringWithFormat:@"%@/media_objects",kAppAPIBaseURLString];
    
    return [self GET:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        if(successBlock){
            @try {
                
                NSMutableArray *arrResponse = [responseObject valueForKey:@"data"];
                
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    [MediaObject entityFromArray:arrResponse inContext:localContext];
                }];
                
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    NSString *strDate = [NSString stringWithFormat:@"%@",[NSDate date]];
                    NSMutableArray *dictTimeStamp = [[NSMutableArray alloc] initWithArray:@[@{@"last_sync_date": strDate}]];
                    [TimeStamp entityFromArray:dictTimeStamp inContext:localContext];
                }];
                
                successBlock(task, responseObject);
            }
            @catch (NSException *exception) {
                [self processExceptionBlock:task blockException:exception];
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
            [self processFailureBlock:task blockError:error];
            failureBlock(task, error);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
}

#pragma mark- Downloading Media Data from server method

/*- (void)downloadMediaData:(NSDictionary *)aParams
 success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
 failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
 
 NSString *url = [aParams objectForKey:@"url"];
 NSArray *docDirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString *mediaPath = [[docDirPath objectAtIndex:0] stringByAppendingPathComponent:[aParams objectForKey:@"fileName"]];
 
 NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL  URLWithString:url]];
 [request setHTTPMethod:@"GET"];
 [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
 
 AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
 operation.outputStream = [[NSOutputStream alloc] initToFileAtPath:mediaPath append:NO];
 
 [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
 NSLog(@"successful download to %@", mediaPath);
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 NSLog(@"Error: %@", error);
 }];
 
 //[self.downloadQueue addOperation:operation];
 }*/

- (void)downloadMediaData:(MediaObject *)objMedia
                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *url = objMedia.object_url;
    NSArray *docDirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *strtemp = @"Temp";
    NSString *strTempName = [strtemp stringByAppendingString:[self getFileName:objMedia]];
    NSString *mediaPath = [[docDirPath objectAtIndex:0] stringByAppendingPathComponent:strTempName];
    
    //NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL  URLWithString:url]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //[request setHTTPMethod:@"GET"];
    //[request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.outputStream = [[NSOutputStream alloc] initToFileAtPath:mediaPath append:NO];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"successful download to %@", mediaPath);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fileRenameFunction:mediaPath];
        });
        successBlock(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"Error: %@", error);
        NSLog(@"Error: %@", operation.responseString);
        failureBlock(operation, error);
    }];
    //[operation start];
    [self.downloadQueue addOperation:operation];
}


-(void)fileRenameFunction:(NSString*)filePath {
    NSString *strOldName = filePath.lastPathComponent;
    NSString *strNewName = [strOldName substringWithRange:NSMakeRange(4,strOldName.length-4)];
    NSArray *docDirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *mediaPath = [[docDirPath objectAtIndex:0] stringByAppendingPathComponent:strNewName];
    NSFileManager * fm = [[NSFileManager alloc] init];
    BOOL result = [fm moveItemAtPath:filePath toPath:mediaPath error:nil];
    if (result){
        NSLog(@"Success");
    }else{
        NSLog(@"fail");
    }
    
}


#pragma mark- Upload media on server method

- (AFHTTPRequestOperation *)uploadMediaWithBase64String:(NSDictionary *)aParams
                                                success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                                failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@/create_media_ios",kAppAPIBaseURLString];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    return [self POST:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        if(successBlock){
            @try {
                NSLog(@"upload_media");
                NSMutableArray *arrResponse = [[NSMutableArray alloc] initWithObjects:[responseObject valueForKey:@"data"], nil];
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    [MediaObject entityFromArray:arrResponse inContext:localContext];
                }];
                successBlock(task, responseObject);
            }
            @catch (NSException *exception) {
                [self processExceptionBlock:task blockException:exception];
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
            [self processFailureBlock:task blockError:error];
            failureBlock(task, error);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
}


#pragma mark- Common method

- (NSURL *)getDocumentDirectoryFileURL:(MediaObject *)objMeida {
    NSArray *docDirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[docDirPath objectAtIndex:0] stringByAppendingPathComponent:[self getFileName:objMeida]];
    return [NSURL fileURLWithPath:filePath];
}

- (BOOL)isMediaFileExistInDocumentDirectory:(MediaObject *)objMeida {
    NSArray *docDirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *mediaPath = [[docDirPath objectAtIndex:0] stringByAppendingPathComponent:[self getFileName:objMeida]];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:mediaPath];
    return fileExists;
}

- (UIImage*)getImageFromDocumentDirectoryFileURL:(MediaObject *)objMeida {
    NSArray *docDirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *mediaPath = [[docDirPath objectAtIndex:0] stringByAppendingPathComponent:[self getFileName:objMeida]];
    UIImage* image = [UIImage imageWithContentsOfFile:mediaPath];
    return image;
}

-(UIImage *)generateThumbImage:(MediaObject *)objMeida
{
    NSURL *url = [self getDocumentDirectoryFileURL:objMeida];
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    CMTime time = [asset duration];
    time.value = 3000;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    
    return thumbnail;
}

-(NSString *)getFileName:(MediaObject *)objMedia {
    
    NSString *strFileName = @"";
    if (objMedia.object_type.integerValue == 1) {
        strFileName = [NSString stringWithFormat:@"%@.png",objMedia.object_id];
    }else if (objMedia.object_type.integerValue == 2) {
        strFileName = [NSString stringWithFormat:@"%@.pdf",objMedia.object_id];
    }else {
        strFileName = [NSString stringWithFormat:@"%@.mp4",objMedia.object_id];
    }
    return strFileName;
}

#pragma mark- Process Exception and Failure Block

-(void)processExceptionBlock:(AFHTTPRequestOperation*)task blockException:(NSException*) exception{
    NSLog(@"Exception : %@",((NSException*)exception));
}

- (NSError*)processFailureBlock:(AFHTTPRequestOperation*) task blockError:(NSError*) error{
    NSLog(@"Error :%@",error);
    return nil;
}


#pragma mark- Delete All table record

- (void) deleteAllEntityObjects{
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        NSArray *arrEntities = [[NSArray alloc] initWithObjects:@"User",@"MediaObject",@"TimeStamp",@"Categories",@"SubCategories",nil];
        
        for (int i=0; i < arrEntities.count; i++) {
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:[arrEntities objectAtIndex:i] inManagedObjectContext:localContext];
            [fetchRequest setEntity:entity];
            
            NSError *error;
            NSArray *items = [localContext executeFetchRequest:fetchRequest error:&error];
            
            for (NSManagedObject *managedObject in items) {
                [localContext deleteObject:managedObject];
            }
            if (![localContext save:&error]) {
            }
        }
    }];
}


@end
