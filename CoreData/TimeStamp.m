//
//  TimeStamp.m
//  Rondogo
//
//  Created by GrepRuby3 on 27/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "TimeStamp.h"


@implementation TimeStamp

@dynamic last_sync_date;

+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
    
    TimeStamp *obj = [TimeStamp MR_findFirstByAttribute:@"last_sync_date" withValue:anID inContext:localContext];
    
    if (!obj) {
        obj = [TimeStamp MR_createInContext:localContext];
    }
    return obj;
}


+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext {
    for(NSDictionary *aDictionary in aArray) {
        [TimeStamp entityFromDictionary:aDictionary inContext:localContext];
    }
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext {
    
    if (![[aDictionary objectForKey:@"last_sync_date"] isKindOfClass:[NSNull class]]){
        
        TimeStamp *obj = (TimeStamp*)[self findOrCreateByID:[aDictionary objectForKey:@"last_sync_date"] inContext:localContext];
        obj.last_sync_date = [aDictionary valueForKey:@"last_sync_date"];
        
        return obj;
    }
    
    return nil;
}


@end
