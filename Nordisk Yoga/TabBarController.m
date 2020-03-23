

#import "TabBarController.h"
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)


@interface TabBarController ()

@end

@implementation TabBarController{
    CGFloat screenWidth;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 13.0, *)) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDarkContent];
    } else {
        // Fallback on earlier versions
    }
    [self viewWillLayoutSubviews];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    // Do any additional setup after loading the view.
    UITabBar *tabBar = self.tabBar;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    CGRect bounds = tabBar.bounds;
    [[tabBar layer] setBorderWidth:0];
    [[tabBar layer] setBorderColor:(__bridge CGColorRef _Nullable)([UIColor whiteColor])];
    tabBar.clipsToBounds = true;
    if([[[UIDevice currentDevice]model] isEqualToString:@"iPad"]){
        if(SYSTEM_VERSION_GREATER_THAN(@"11")){

            bounds.origin.y += (bounds.size.height-75);

        }
        else
            bounds.origin.y += (bounds.size.height-80);

    }else{
        if(screenHeight == 812 && screenWidth == 375){
            NSLog(@"XXXXXX Iphone");
            bounds.origin.y += (bounds.size.height-92);
        }else{
            bounds.origin.y += (bounds.size.height-80);
        }
    }
   
    [tabBar setBounds:bounds];
    [tabBar setBackgroundColor:[UIColor clearColor]];
}
//const CGFloat kBarHeight = ([[UIScreen mainScreen] bounds].size.height == 812) ? 80 :72;
- (void)viewWillLayoutSubviews {
    const CGFloat kBarHeight = ([[UIScreen mainScreen] bounds].size.height == 812) ? 80 : 72;
    CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
    tabFrame.size.height = kBarHeight;
    tabFrame.origin.y = self.view.frame.size.height - kBarHeight;
    self.tabBar.frame = tabFrame;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
