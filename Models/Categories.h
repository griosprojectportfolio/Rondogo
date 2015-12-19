//
//  Categories.h
//  Rondogo
//
//  Created by GrepRuby3 on 18/12/15.
//  Copyright © 2015 GrepRuby3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Categories : NSManagedObject

@property (nonatomic, retain) NSNumber *category_id;
@property (nonatomic, retain) NSString *category_name;
@property (nonatomic, retain) NSString *category_language;
@property (nonatomic, retain) NSString *cat_server_url;
@property (nonatomic, retain) NSString *cat_local_url;
@property (nonatomic, retain) NSNumber *cat_sequence_no;
@property (nonatomic, retain) NSNumber *is_deleted;

+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext*)localContext;
+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext;

@end

