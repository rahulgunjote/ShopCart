//
//  ProductCell.m
//  ShopCart
//
//  Created by Rahul Gunjote on 03/03/16.
//  Copyright © 2016 Rahul Gunjote. All rights reserved.
//

#import "ProductCell.h"
#import "Product.h"

@implementation ProductCell

- (void)awakeFromNib {
    self.layer.masksToBounds = true;
    [self.buttonAddToCart addTarget:self action:@selector(didTapButtonAddToCart:) forControlEvents:UIControlEventTouchUpInside];
    // Initialization code
}
-(void)didTapButtonAddToCart:(UIButton*)sender{
    if (self.didTapAddToCartHandler) {
        self.didTapAddToCartHandler();
    }
}
@end
