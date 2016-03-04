//
//  CartItem.h
//  ShopCart
//
//  Created by Rahul Gunjote on 03/03/16.
//  Copyright © 2016 Rahul Gunjote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface CartItem : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(NSInteger)countOfCartItems;

@end

NS_ASSUME_NONNULL_END

#import "CartItem+CoreDataProperties.h"
