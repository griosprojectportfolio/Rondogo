//
//  TimeStamp.h
//  Rondogo
//
//  Created by GrepRuby3 on 27/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TimeStamp : NSManagedObject

@property (nonatomic, retain) NSString * last_sync_date;

+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext*)localContext;
+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext;

@end
