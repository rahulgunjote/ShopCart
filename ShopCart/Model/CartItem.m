//
//  CartItem.m
//  ShopCart
//
//  Created by Rahul Gunjote on 03/03/16.
//  Copyright © 2016 Rahul Gunjote. All rights reserved.
//

#import "CartItem.h"

@implementation CartItem

// Insert code here to add functionality to your managed object subclass
+(NSInteger)countOfCartItems{

    NSManagedObjectContext *context = [[CDStack defaultStack] managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CartItem"];
    NSError *fetchError;
    NSInteger count = [context countForFetchRequest:request error:&fetchError];
    return count;
}
@end
