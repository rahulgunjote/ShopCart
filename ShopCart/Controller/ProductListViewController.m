//
//  ProductListViewController.m
//  ShopCart
//
//  Created by Rahul Gunjote on 03/03/16.
//  Copyright © 2016 Rahul Gunjote. All rights reserved.
//

#import "ProductListViewController.h"
#import "ProductCell.h"
#import "Product.h"
#import "CartItem.h"

static NSString * const kCellReuseIdentifier=@"ProductCell";
@interface ProductListViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    CGFloat         kHorizontalInsets;
    CGFloat         kVerticalInsets;
    ProductCell     *offscreenCell;
}
@property (nonatomic,strong) NSMutableArray             *products;
@property (nonatomic,weak)   IBOutlet UICollectionView  *collectionView;
@property (nonatomic,strong) UITabBarItem               *tabItemCart;
@property (nonatomic,strong) NSNumber                   *cartCount;
@end

@implementation ProductListViewController

-(NSArray *)products{
    if (!_products) {
        _products = [[NSMutableArray alloc] init];
    }
    return _products;
}
- (void)viewDidLoad {

    [super viewDidLoad];

    // Configure collection View
    kHorizontalInsets = 10.0;
    kVerticalInsets = 10.0;
    UINib *nib = [UINib nibWithNibName:@"ProductCell" bundle:nil];
    // Register nib for custom cell with Collection View
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:kCellReuseIdentifier];

    // Keep track of cart items count
    self.tabItemCart = [self.tabBarController.tabBar.items lastObject];
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(cartCount)) options:NSKeyValueObservingOptionNew context:NULL];
    self.cartCount = @([CartItem countOfCartItems]);

    // Get products data from server
    [self fetchPhotoRecords];

}
-(void)fetchPhotoRecords {

    NSString *datasourceUrl =  @"https://mobiletest-hackathon.herokuapp.com/getdata/";
    
    // Create request using data url
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:datasourceUrl]];
    // Configure NSURLSession
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:true];

    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:false];
        }];
        // IF error show alert
        if (error) {
            [self showAlertWithTitle:@"Error!" message:error.localizedDescription];
            [self reloadCollectionView];
            return;
        }
        if (data){
            // Parse JSON
            NSError *jsonError = nil;
            NSDictionary *productsDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonError) {
               [self showAlertWithTitle:@"Error!" message:jsonError.localizedDescription];
            }else{
                [self.products removeAllObjects];
                NSArray *products = [productsDict valueForKey:@"products"];
                for (NSDictionary *productDict in products) {
                    Product *newProduct = [[Product alloc] initWithDictionary:productDict];
                    [self.products addObject:newProduct];
                }
                [self reloadCollectionView];
            }

        }else{
            [self showAlertWithTitle:@"Oops!" message:@"Data not found"];
            [self reloadCollectionView];
        }

    }] resume];
}
-(void)reloadCollectionView{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (self.products.count) {
            self.collectionView.hidden = false;
            [self.collectionView reloadData];
        }else
        {
            self.collectionView.hidden = true;
        }
    }];
}

#pragma mark- colloection view delegates

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [self.products count];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{

    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth = 1;
    cell.layer.cornerRadius = 5.0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    ProductCell *cell = [cv dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    Product *product = self.products[indexPath.item];
    [self configureCell:cell forProduct:product];
    cell.didTapAddToCartHandler = ^{
        [self addProductToCart:product atIndexpath:indexPath];
    };
    return cell;
}

-(void) configureCell:(ProductCell *)cell forProduct:(Product *)product{

    [cell.imageViewProductImage sd_setImageWithURL:[NSURL URLWithString:product.imageURL] placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
    cell.labelName.text = product.name;
    cell.labelPrice.text = product.price;
    cell.labelVendorName.text = product.vendorName;
    cell.labelVendorAddress.text = product.vendorAddress;

    [cell setNeedsLayout];
    [cell layoutIfNeeded];
}

#pragma mark CollectionView layout
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kHorizontalInsets;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kVerticalInsets;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kVerticalInsets, kHorizontalInsets, kVerticalInsets, kHorizontalInsets);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat targetWidth  = (self.collectionView.bounds.size.width - 3 * kHorizontalInsets) / 2;
    //Use dummy cell to calculate height
    ProductCell *cell= offscreenCell;
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProductCell" owner:self options:nil] firstObject];
        offscreenCell = cell;
    }
    [self configureCell:cell forProduct:self.products[indexPath.item]];
    // Config cell and let system determine size
    // Cell's size is determined in nib file, need to set it's width (in this case),
    cell.bounds = CGRectMake(0, 0, targetWidth, cell.bounds.size.height);
    cell.contentView.bounds = cell.bounds;

    // Layout subviews
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
    // Still need to force the width, since width can be smalled due to break mode of labels
    size.width = targetWidth;
    return cell.bounds.size;

}
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [self.collectionView.collectionViewLayout invalidateLayout];
}
#pragma mark
#pragma mark Utility
-(void)addProductToCart:(Product *)product atIndexpath:indexPath{

    NSManagedObjectContext *context = [[CDStack defaultStack] managedObjectContext];
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"CartItem"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", product.name];
    [fetch setPredicate:predicate];
    NSError *fetchError;
    CartItem *cartItem = [[context executeFetchRequest:fetch error:&fetchError] firstObject];

    if(!cartItem) {
        //not there so create it and save
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CartItem" inManagedObjectContext:context];
        // Initialize Record
        cartItem = [[CartItem alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    }
    cartItem.name = product.name;
    cartItem.price = @([product.price doubleValue]);
    cartItem.productImage = product.imageURL;
    cartItem.vendorName = product.vendorName;
    cartItem.vendorAddress = product.vendorAddress;
    cartItem.vendorPhoneNumber = product.phoneNumber;
    cartItem.quantity = @1;
    cartItem.addedDate = [NSDate date];

    NSError *saveError;
    if ([context save:&saveError]) {
        NSLog(@"");
    }
    [self showAnimationForAddToCartAtIndexPath:indexPath];
}
- (void)showAnimationForAddToCartAtIndexPath:(NSIndexPath*)indexPath {
    // get the cell using indexpath
    ProductCell *cell = (ProductCell *)[self.collectionView cellForItemAtIndexPath:indexPath];

    // get the imageview using cell
    UIImageView *imgV = cell.imageViewProductImage;

    // get the exact location of image
    CGRect rect = [imgV.superview convertRect:imgV.frame fromView:nil];
    rect = CGRectMake(5, (rect.origin.y*-1)-10, imgV.frame.size.width, imgV.frame.size.height);

    // create new image
    UIImageView *starView = [[UIImageView alloc] initWithImage:imgV.image];
    [starView setFrame:rect];
    starView.layer.cornerRadius=5;
    starView.layer.borderColor=[[UIColor blackColor]CGColor];
    starView.layer.borderWidth=1;
    [self.view addSubview:starView];

    CGFloat animationDuration = 0.6;
    // begin ---- apply position animation
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration=animationDuration;
    pathAnimation.delegate=self;

    // tab-bar right side item frame-point = end point
    CGRect tabbarFrame = self.tabBarController.view.frame;
    CGPoint endPoint = CGPointMake(tabbarFrame.size.width-100 , tabbarFrame.size.height-44);

    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, starView.frame.origin.x, starView.frame.origin.y);
    CGPathAddCurveToPoint(curvedPath, NULL, endPoint.x, starView.frame.origin.y, endPoint.x, starView.frame.origin.y, endPoint.x, endPoint.y);
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    // apply transform animation
    CABasicAnimation *basic=[CABasicAnimation animationWithKeyPath:@"transform"];
    [basic setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.25, 0.25, 0.25)]];
    [basic setAutoreverses:NO];
    [basic setDuration:0.65];

    [starView.layer addAnimation:pathAnimation forKey:@"curveAnimation"];
    [starView.layer addAnimation:basic forKey:@"transform"];

    [starView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:animationDuration];
    [self performSelector:@selector(incrementCount) withObject:nil afterDelay:animationDuration];
}
- (void)incrementCount {
    self.cartCount = @([CartItem countOfCartItems]);
}
-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:^{

        }];
    }];
    
}
#pragma mark clearance methods
-(void)dealloc{
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(cartCount))];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// update the Badge number
#pragma mark KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(cartCount))]) {
        NSNumber *count =  [change valueForKey:@"new"];
        if (![count isEqual:[NSNull null]]) {
          self.tabItemCart.badgeValue=[NSString stringWithFormat:@"%li",(long)[count integerValue]];
        }
    }else
    {
        [super  observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
