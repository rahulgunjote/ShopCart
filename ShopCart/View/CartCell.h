//
//  CartCell.h
//  ShopCart
//
//  Created by Rahul Gunjote on 03/03/16.
//  Copyright © 2016 Rahul Gunjote. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RemoveFromCartHandler)(NSIndexPath *indexPath);
typedef void(^CallHandler)(NSIndexPath *indexPath);
@interface CartCell : UITableViewCell
@property(nonatomic, weak)IBOutlet UIImageView *imageViewProductImage;
@property(nonatomic, weak)IBOutlet UILabel     *labelName;
@property(nonatomic, weak)IBOutlet UILabel     *labelPrice;
@property(nonatomic, weak)IBOutlet UILabel     *labelVendorName;
@property(nonatomic, weak)IBOutlet UILabel     *labelVendorAddress;
@property(nonatomic, weak)IBOutlet UIButton    *buttonRemoveFromCart;
@property(nonatomic, weak)IBOutlet UIButton    *buttonCallVendor;
@property(nonatomic, copy)RemoveFromCartHandler didTapRemoveFromCartHandler;
@property(nonatomic, copy)CallHandler didTapCallVendorHandler;

@property(nonatomic, strong)NSIndexPath *indexPath;
@end
