//
//  Categories.h
//  Rondogo
//
//  Created by GrepRuby3 on 22/12/15.
//  Copyright © 2015 GrepRuby3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Categories : NSManagedObject

@property (nonatomic, retain) NSNumber *cat_sequence;
@property (nonatomic, retain) NSString *cat_imageUrl;
@property (nonatomic, retain) NSNumber *cat_id;
@property (nonatomic, retain) NSString *cat_language;
@property (nonatomic, retain) NSString *cat_name;
@property (nonatomic, retain) NSNumber *is_deleted;


+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext*)localContext;
+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext;

@end
