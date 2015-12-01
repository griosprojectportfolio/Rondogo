//
//  MediaObject.h
//  Rondogo
//
//  Created by GrepRuby3 on 26/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MediaObject : NSManagedObject

@property (nonatomic, retain) NSNumber * category_id;
@property (nonatomic, retain) NSNumber * object_id;
@property (nonatomic, retain) NSNumber * is_deleted;
@property (nonatomic, retain) NSString * object_name_english;
@property (nonatomic, retain) NSString * object_name_hebrew;
@property (nonatomic, retain) NSString * object_server_url_english;
@property (nonatomic, retain) NSString * object_server_url_hebrew;
@property (nonatomic, retain) NSNumber * object_type;
@property (nonatomic, retain) NSNumber * sub_category_id;

+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext*)localContext;
+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext;

@end
