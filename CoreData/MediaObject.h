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

@property (nonatomic, retain) NSNumber * object_id;
@property (nonatomic, retain) NSString * object_url;
@property (nonatomic, retain) NSNumber * object_type;
@property (nonatomic, retain) NSNumber * is_deleted;
@property (nonatomic, retain) NSNumber * subCategory_id;
@property (nonatomic, retain) NSString * object_name;
@property (nonatomic, retain) NSNumber * object_sequence;

+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext*)localContext;
+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext;

@end
