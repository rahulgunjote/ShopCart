//
//  ProductCell.h
//  ShopCart
//
//  Created by Rahul Gunjote on 03/03/16.
//  Copyright © 2016 Rahul Gunjote. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddToCartHandler)();
@interface ProductCell : UICollectionViewCell

@property(nonatomic, weak)IBOutlet UIImageView *imageViewProductImage;
@property(nonatomic, weak)IBOutlet UILabel     *labelName;
@property(nonatomic, weak)IBOutlet UILabel     *labelPrice;
@property(nonatomic, weak)IBOutlet UILabel     *labelVendorName;
@property(nonatomic, weak)IBOutlet UILabel     *labelVendorAddress;
@property(nonatomic, weak)IBOutlet UIButton    *buttonAddToCart;

@property(nonatomic, copy)AddToCartHandler didTapAddToCartHandler;
@end
