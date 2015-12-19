//
//  AppApi.m
//  Rondogo
//
//  Created by GrepRuby3 on 14/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//
#import "MediaObject.h"
#import "TimeStamp.h"
#import "User.h"
#import "AppApi.h"

/* API Constants */
//static NSString * const kAppAPIBaseURLString = @"http://192.168.10.40:4000/api/v1";
//static NSString * const kAppMediaBaseURLString = @"http://192.168.10.40:4000";

static NSString * const kAppAPIBaseURLString = @"https://rondogo.herokuapp.com/api/v1";
static NSString * const kAppMediaBaseURLString = @"https://rondogo.herokuapp.com";

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

#pragma mark- Login User

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
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }
            @catch (NSException *exception) {
                [self processExceptionBlock:task blockException:exception];
            }
        }
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
            [self processFailureBlock:task blockError:error];
            failureBlock(task, error);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
}

#pragma mark- SignUp User

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
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }
            @catch (NSException *exception) {
                [self processExceptionBlock:task blockException:exception];
            }
        }
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
            [self processFailureBlock:task blockError:error];
            failureBlock(task, error);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
}

#pragma mark- Update User

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
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }
            @catch (NSException *exception) {
                [self processExceptionBlock:task blockException:exception];
            }
        }
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
            [self processFailureBlock:task blockError:error];
            failureBlock(task, error);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
}


#pragma mark- Forgot password

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
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }
            @catch (NSException *exception) {
                [self processExceptionBlock:task blockException:exception];
            }
        }
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
            [self processFailureBlock:task blockError:error];
            failureBlock(task, error);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
}

#pragma mark- SignOut user

- (AFHTTPRequestOperation *)signOutUser:(NSDictionary *)aParams
                                   success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                   failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
    
    [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
    NSString *url = [NSString stringWithFormat:@"%@/sessions/logout",kAppAPIBaseURLString];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    return [self DELETE:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        if(successBlock){
            @try {
                NSLog(@"logout");
                NSHTTPCookie *cookie;
                NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                for (cookie in [storage cookies]) {
                    [storage deleteCookie:cookie];
                }
                //[self deleteAllEntityObjects];
                successBlock(task, responseObject);
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }
            @catch (NSException *exception) {
                [self processExceptionBlock:task blockException:exception];
            }
        }
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
            [self processFailureBlock:task blockError:error];
            failureBlock(task, error);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
}


#pragma mark- Sync Call Methods

- (AFHTTPRequestOperation *)getAllObjects:(NSDictionary *)aParams
                                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{

    NSString *url = [NSString stringWithFormat:@"%@/download_media",kAppAPIBaseURLString];
    
    return [self POST:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        if(successBlock){
            @try {
                NSLog(@"getAllObjects");
                /* Ref : http://stackoverflow.com/questions/14459321/magical-record-save-in-background */
                
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
        }
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
            [self processFailureBlock:task blockError:error];
            failureBlock(task, error);
        }
    }];
}

#pragma mark- Method to Downloading Media Data from server

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

- (void)downloadMediaData:(NSDictionary *)aParams
                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  NSString *url = [aParams objectForKey:@"url"];
  NSArray *docDirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *strtemp = @"Temp";
  NSString *strTempName = [strtemp stringByAppendingString:[aParams objectForKey:@"fileName"]];
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
      [self fileRenameFunction:mediaPath];
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





/* // Previous approach

- (void)downloadMediaData:(NSDictionary *)aParams
                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
    
    NSString *url = [aParams objectForKey:@"url"];
    NSArray *docDirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *mediaPath = [[docDirPath objectAtIndex:0] stringByAppendingPathComponent:[aParams objectForKey:@"fileName"]];
    
    AFHTTPRequestOperation *operation = [self GET:url
                                       parameters:nil
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSLog(@"successful download to %@", mediaPath);
                                              successBlock(operation, responseObject);
                                          }
                                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              NSLog(@"Error: %@", error);
                                              failureBlock(operation, error);
                                          }];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:mediaPath append:NO];
     
}
*/

#pragma mark - Upload media with Base64String

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




#pragma mark - Upload media with Base64String

- (AFHTTPRequestOperation *)uploadMediaWithBase64String:(NSDictionary *)aParams
                                                success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                                failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@/upload_media",kAppAPIBaseURLString];
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
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }
            @catch (NSException *exception) {
                [self processExceptionBlock:task blockException:exception];
            }
        }
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
            [self processFailureBlock:task blockError:error];
            failureBlock(task, error);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
}


#pragma mark Methods to get :- File Path, Path Image, Generate Thumnil image ETC

- (NSURL *)getDocumentDirectoryFileURL:(NSDictionary *)aParams {
    NSArray *docDirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[docDirPath objectAtIndex:0] stringByAppendingPathComponent:[aParams objectForKey:@"fileName"]];
    return [NSURL fileURLWithPath:filePath];
}

- (BOOL)isMediaFileExistInDocumentDirectory:(NSDictionary *)aParams{
    NSArray *docDirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *mediaPath = [[docDirPath objectAtIndex:0] stringByAppendingPathComponent:[aParams objectForKey:@"fileName"]];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:mediaPath];
    return fileExists;
}

- (UIImage*)getImageFromDocumentDirectoryFileURL:(NSDictionary *)aParams{
    NSArray *docDirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *mediaPath = [[docDirPath objectAtIndex:0] stringByAppendingPathComponent:[aParams objectForKey:@"fileName"]];
    UIImage* image = [UIImage imageWithContentsOfFile:mediaPath];
    return image;
}

-(UIImage *)generateThumbImage:(NSDictionary *)aParams
{
    NSURL *url = [self getDocumentDirectoryFileURL:aParams];
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    CMTime time = [asset duration];
    time.value = 3000;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    
    return thumbnail;
}

#pragma mark- Process Exception and Failure Block

-(void)processExceptionBlock:(AFHTTPRequestOperation*)task blockException:(NSException*) exception{
    NSLog(@"Exception : %@",((NSException*)exception));
}

- (NSError*)processFailureBlock:(AFHTTPRequestOperation*) task blockError:(NSError*) error{
    //Common Method for error handling
    // Do some thing for error handling
    NSLog(@"Error :%@",error);
    return nil;
}


#pragma mark Delete All table record

- (void) deleteAllEntityObjects{
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        NSArray *arrEntities = [[NSArray alloc] initWithObjects:@"User", @"MediaObject",@"TimeStamp",nil];
        
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


#pragma mark - Some testing Methods

// Method to Upload image in Multipart

- (void)uploadImage:(NSDictionary *)aParams
            success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
            failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@",[aParams objectForKey:@"url"]];
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.png"];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    [self POST:url parameters:aParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSError *error;
        BOOL success = [formData appendPartWithFileURL:fileURL name:@"image" fileName:filePath mimeType:@"image/png" error:&error];
        if (!success)
            NSLog(@"appendPartWithFileURL error: %@", error);
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

// Method to Upload Data ( UIImage + Video ) in Multipart

- (void)uploadMediaData:(NSDictionary *)aParams
                success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
    
    NSURL *fileURL = [self getDocumentDirectoryFileURL:aParams];
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:self.baseURL];
    
    NSURL *requestUrl = [NSURL URLWithString:@"/post" relativeToURL:self.baseURL];
    
    __block BOOL completeBlockCalled = NO;
    NSError *errorFormAppend;
    __block NSError *errorPost;
    
    NSURLSessionDataTask *task = [sessionManager POST:requestUrl.absoluteString
                                           parameters:nil
                            constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                NSError *error = errorFormAppend;
                                [formData appendPartWithFileURL:fileURL name:@"test.txt" error:&error];
                                
                            } success:^(NSURLSessionDataTask *task, id responseObject) {
                                completeBlockCalled = YES;
                                
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                errorPost = error;
                            }];
}

//[self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

//self.requestSerializer = [AFJSONRequestSerializer serializer];
//self.requestSerializer = [AFHTTPRequestSerializer serializer];
//self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//[self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

//[self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//[self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
// [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];


#pragma mark - Fetch Categories and sub Categories

- (AFHTTPRequestOperation *)getAllCategories:(NSDictionary *)aParams
                                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@/categories",kAppAPIBaseURLString];
    
    return [self GET:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        if(successBlock){
            @try {
                NSMutableArray *arrResponse = [responseObject valueForKey:@"data"];
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    [MediaObject entityFromArray:arrResponse inContext:localContext];
                }];
                successBlock(task, responseObject);
            }
            @catch (NSException *exception) {
                [self processExceptionBlock:task blockException:exception];
            }
        }
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
            [self processFailureBlock:task blockError:error];
            failureBlock(task, error);
        }
    }];
}

- (AFHTTPRequestOperation *)getAllSubCategories:(NSDictionary *)aParams
                                     success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                     failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@/sub_categories",kAppAPIBaseURLString];
    
    return [self GET:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
        if(successBlock){
            @try {
                NSMutableArray *arrResponse = [responseObject valueForKey:@"data"];
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    [MediaObject entityFromArray:arrResponse inContext:localContext];
                }];
                successBlock(task, responseObject);
            }
            @catch (NSException *exception) {
                [self processExceptionBlock:task blockException:exception];
            }
        }
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
            [self processFailureBlock:task blockError:error];
            failureBlock(task, error);
        }
    }];
}


@end
