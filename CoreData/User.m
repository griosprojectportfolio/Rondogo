//
//  User.m
//  Rondogo
//
//  Created by GrepRuby3 on 26/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "User.h"


@implementation User

@dynamic contact_no;
@dynamic email;
@dynamic first_name;
@dynamic is_admin;
@dynamic last_name;
@dynamic user_id;
@dynamic user_name;
@dynamic created_at;
@dynamic updated_at;


+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
    
    User *obj = [User MR_findFirstByAttribute:@"user_id" withValue:anID inContext:localContext];
    
    if (!obj) {
        obj = [User MR_createInContext:localContext];
    }
    return obj;
}


+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext {
    for(NSDictionary *aDictionary in aArray) {
        [User entityFromDictionary:aDictionary inContext:localContext];
    }
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext {
    
    if (![[aDictionary objectForKey:@"id"] isKindOfClass:[NSNull class]]){
        
        User *obj = (User*)[self findOrCreateByID:[aDictionary objectForKey:@"id"] inContext:localContext];
        
        //[User MR_createInContext:localContext];
        //MediaData *obj = [MediaData MR_createEntity];
        
        obj.user_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"id"] integerValue]];
        
        if (![[aDictionary objectForKey:@"contact_no"] isKindOfClass:[NSNull class]])
        obj.contact_no = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"contact_no"] integerValue]];
        
        if (![[aDictionary objectForKey:@"email"] isKindOfClass:[NSNull class]])
        obj.email = [aDictionary valueForKey:@"email"] ;
        
        if (![[aDictionary objectForKey:@"first_name"] isKindOfClass:[NSNull class]])
        obj.first_name = [aDictionary objectForKey:@"first_name"];
        
        if (![[aDictionary objectForKey:@"is_admin"] isKindOfClass:[NSNull class]])
        obj.is_admin =[NSNumber numberWithInteger:[[aDictionary objectForKey:@"is_admin"] integerValue]];
        
        if (![[aDictionary objectForKey:@"last_name"] isKindOfClass:[NSNull class]])
        obj.last_name = [aDictionary valueForKey:@"last_name"];
        
        if (![[aDictionary objectForKey:@"user_name"] isKindOfClass:[NSNull class]])
        obj.user_name =[aDictionary valueForKey:@"user_name"] ;
        
        if (![[aDictionary objectForKey:@"created_at"] isKindOfClass:[NSNull class]])
        obj.created_at =[aDictionary valueForKey:@"created_at"];
        
        if (![[aDictionary objectForKey:@"updated_at"] isKindOfClass:[NSNull class]])
        obj.updated_at =[aDictionary valueForKey:@"updated_at"];

        return obj;
    }
    return nil;
}

@end
