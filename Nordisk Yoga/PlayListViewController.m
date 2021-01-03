

#import "PlayListViewController.h"
#import "AppDelegate.h"
#import "SongsIAPHelper.h"
#import "M13ProgressHUD.h"
#import "M13ProgressViewRing.h"
#import "AFNetworking.h"
#import "IAPHelper.h"
#import "Reachability.h"
@interface PlayListViewController ()
{
    NSArray *_products;
    M13ProgressHUD *HUD;
}
@property (strong, nonatomic) IBOutlet UIImageView *fadeImage;
@property (strong, nonatomic) IBOutlet UIImageView *bgImage;
@property (strong, nonatomic) IBOutlet UIView *superView;

@end

@implementation PlayListViewController{
    NSArray *mainAF;
    NSString *selected;
    NSMutableArray *prodIDS;
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    NSLog(@"iphone 4s width = 320 and height = 480");
//    NSLog(@"iphone SE width = 320 and height = 568");
//    NSLog(@"iphone 8 width = 375 and height = 667");
//    NSLog(@"iphone 8plus width = 414 and height = 736");
//    NSLog(@"ipad 9.7 width = 768 and height = 1024");
//    NSLog(@"ipad 10.5 width = 834 and height = 1112 ");
//    NSLog(@"ipad 12.9 width = 1024 and height = 1366 ");
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    UIImageView *fade = [[UIImageView alloc]init];
    
        if(screenWidth == 320){
        [fade setImage:[UIImage imageNamed:@"iSE-fade.png"]];
        [fade setFrame:CGRectMake(0,20, 320, 106)];
    }
    else if (screenWidth == 375){
        if(screenHeight == 812){
            [fade setImage:[UIImage imageNamed:@"i8-fade.png"]];
            [fade setFrame:CGRectMake(0,44, 375, 106)];
        }else{
            [fade setImage:[UIImage imageNamed:@"i8-fade.png"]];
            [fade setFrame:CGRectMake(0,20, 375, 106)];
        }
    }
    else if (screenWidth == 414){

        [fade setImage:[UIImage imageNamed:@"i8Plus-fade.png"]];
        [fade setFrame:CGRectMake(0,20, 414, 106)];
    }
    
    else if (screenWidth == 768){
        [fade setImage:[UIImage imageNamed:@"i9.7-fade.png"]];
        [fade setFrame:CGRectMake(0,20, 768, 197)];
    }
    else if (screenWidth == 834){
        [fade setImage:[UIImage imageNamed:@"i10.9-fade.png"]];
        [fade setFrame:CGRectMake(0,20, 834, 197)];
    }
    else if (screenWidth == 1024){
        [fade setImage:[UIImage imageNamed:@"i12.9-fade.png"]];
        [fade setFrame:CGRectMake(0,20, 1024, 197)];
    }
    [_superView insertSubview:fade atIndex:2];
    NSLog(@"%@",_superView.subviews);
    self.appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    _activityIndicator.hidesWhenStopped = YES;
    selected=@"0-0";
    prodIDS = [[NSMutableArray alloc]init];
    
    _scrubbing = FALSE;
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.videoController = [[AVPlayerViewController alloc] init];
_audioPlayer.delegate = self;
    //when it creates an instance it asks the app store what all are in the store which can be purchased and it first checks in the logs (which is the nsuerdefautls] for any already purchased
    
    //and when it requestProductsWithCompletionHandler it then asks the store what all are available to buy
    
    //IN THE SONGS IPA HELPER GO AND MAKE A REQUEST TO API TO GET ALL THE PRODUCT IDS SO THAT IT CAN SEE IN STORE KIT
    [_activityIndicator startAnimating];
    [self getHeading];
    [self getData];
    //this is necessary step
    _currPlaying = -1;
    _currVideoPlaying = -1;
    _songsTableView.delegate = self;
    _songsTableView.dataSource = self;
    _songsTableView.allowsSelection=true;
    
    BOOL restoreDone = [[NSUserDefaults standardUserDefaults] boolForKey:@"restoreDone"];
    if (restoreDone)
    {
        _mRestoreBtn.hidden = true;
    }
    

    
}
-(void)getData{
    __block NSMutableArray *result = [[NSMutableArray alloc]init];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.nordiskyoga.dk/api/files"]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *err = nil;
        id data = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:&err];
        if([data[@"error"] isEqual:@(1)]){
            NSArray *resData = data[@"result"];
            result = resData;
        }
        [self dataDeleteProg];
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        //  ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓  to get section numbers
        for(int i = 0 ; i < [result count] ; i++){
            NSDictionary *temp = result[i];
            //            NSLog(@" %@  ->   %@  text -> %15@   type -> %@ ",temp[@"section_priority"] , temp[@"file_priority"],temp[@"text"] , temp[@"type"]);
            [arr addObject:temp[@"section_priority"]];
        }
        //↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
        
        //  ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓  to get unique section numbers
        int j = 0;
        NSMutableArray *uni = [[NSMutableArray alloc]init];
        for(int i=0 ;i<[arr count];i++){
            if([[arr objectAtIndex:i] integerValue] != j){
                j =[[arr objectAtIndex:i] integerValue];
                [uni addObject:[arr objectAtIndex:i]];
            }
        }
        //↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
        NSMutableArray *mutData = [[NSMutableArray alloc]init];
        for (int j =0 ; j<[uni count]; j++)
        {
            int flag = false;
            NSMutableArray *temp1 = [[NSMutableArray alloc]init];
            for(int i = 0 ; i < [result count] ; i++)
            {
                NSDictionary *t = [NSDictionary dictionary];
                NSDictionary *temp = result[i];
                if(temp[@"section_priority"] == uni[j])
                {
                    if(flag == false)
                    {
                        flag = true;
                        [temp1 addObject:temp[@"text"]];
                    }
                    //adding product ids to an array so that it can be sent to songs iap helper for initialization
                    if(![temp[@"appstore_id"] isEqualToString:@""])
                        [prodIDS addObject:temp[@"appstore_id"]];
                    t = @{
                          @"title":temp[@"title"],
                          @"type":temp[@"type"],
                          @"access":temp[@"access"],
                          @"url":temp[@"url"],
                          @"productID":temp[@"appstore_id"],
                          @"name":temp[@"name"],
                          @"length":temp[@"length"],
                          };
                    [temp1 addObject:t];
                }
            }
            [mutData addObject:temp1];
            //push in mut here
        }
        NSLog(@"%@  count is -> %ld",mutData,[mutData count]);
        mainAF = mutData;
        [self createProgEntry:[NSKeyedArchiver archivedDataWithRootObject:mainAF]];
        
        //perform initialization of store kit here so that the product ids are correctly sent to the check if they are available in the nsuerdefaults or in the store
        
        [SongsIAPHelper setProductIds:prodIDS];
        [[SongsIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            if (success) {
                NSLog(@"Success get IAP products ");
                _products = products;
                for(int i= 0; i< [_products count]; i++)
                {
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    SKProduct *product = [_products objectAtIndex:i];
                    NSLog(@" %d. %@",i,product.productIdentifier);
                    if ([[SongsIAPHelper sharedInstance] productPurchased:product.productIdentifier])
                        [defaults setBool:YES forKey:product.productIdentifier];
                    else
                        [defaults setBool:NO forKey:product.productIdentifier];
                    [defaults synchronize];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_songsTableView reloadData];
                });
                
                
            }
        }];
        
        
        [_songsTableView reloadData];
        [_activityIndicator stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERR: %@", [error description]);
        
        mainAF = [NSKeyedUnarchiver unarchiveObjectWithData:[self makeProgFromCoreData]];
        
        [_songsTableView reloadData];
        [_activityIndicator stopAnimating];
        
    }];
    
    [operation start];
    
}
-(void)getHeading{
    __block NSMutableArray *result = [[NSMutableArray alloc]init];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.nordiskyoga.dk/api/headings"]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *err = nil;
        id data = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:&err];
        if([data[@"error"] isEqual:@(1)]){
            NSArray *resData = data[@"result"];
            result = resData;
        }
        [self dataDeleteHeading1];
        for (int i=0; i<[result count]; i++) {
            NSDictionary *temp = result[i];
            if([temp[@"type"] isEqualToString:@"files"]){
                
                [self createHeadingEntry:temp[@"text"]];
                NSMutableDictionary *attrsDictionary = [NSMutableDictionary dictionary];
                
                if([[[UIDevice currentDevice]model] isEqualToString:@"iPad"])
                    attrsDictionary[NSFontAttributeName] =[UIFont fontWithName:@"Optima-Bold" size:60.0];
                else
                    attrsDictionary[NSFontAttributeName] =[UIFont fontWithName:@"Optima-Bold" size:33.0];
                NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:temp[@"text"] attributes:attrsDictionary];
                [_headingLabel setAttributedText:attrString];
                break;
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERR: %@", [error description]);
        NSMutableDictionary *attrsDictionary = [NSMutableDictionary dictionary];
        
        if([[[UIDevice currentDevice]model] isEqualToString:@"iPad"])
            attrsDictionary[NSFontAttributeName] =[UIFont fontWithName:@"Optima-Bold" size:60.0];
        else
            attrsDictionary[NSFontAttributeName] =[UIFont fontWithName:@"Optima-Bold" size:33.0];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[self makeHeadingFromCoreData] attributes:attrsDictionary];
        [_headingLabel setAttributedText:attrString];
    }];
    [operation start];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}


- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            NSLog(@"productPurchased");
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:product.productIdentifier];
            [defaults synchronize];
            
            [self.songsTableView reloadData];
            *stop = YES;
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if ([_audioPlayer isPlaying])
    {
        [_audioPlayer stop];
    }
    
    NSIndexPath *ipath = [_songsTableView indexPathForSelectedRow];
    [_songsTableView.delegate tableView:_songsTableView willSelectRowAtIndexPath:ipath];
    
    
}

-(void)playTheVideo:(NSString*)path indexP:(NSIndexPath*)indexPath{
    
    NSURL    *fileURL    =   [NSURL fileURLWithPath:path];
            NSLog(@"Video url : %@",path);
    AVPlayer *player = [[AVPlayer alloc] initWithURL:fileURL];
    if (@available(iOS 12.0, *)) {
        [player setPreventsDisplaySleepDuringVideoPlayback:YES];
    } else {
        // Fallback on earlier versions
    }
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];

    NSError *setCategoryError = nil;
    BOOL success = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    if (!success) { /* handle the error condition */ }

    NSError *activationError = nil;
    success = [audioSession setActive:YES error:&activationError];
    if (!success) { /* handle the error condition */ }
    [self.videoController setPlayer:player];
//    player remov
    [self presentViewController:self.videoController animated:YES completion:^{
        [player play];

    }];
//            [self.videoController.moviePlayer prepareToPlay];
//            [self.videoController.moviePlayer play];
//            [self presentMoviePlayerViewControllerAnimated:self.videoController];
    
    [_songsTableView deselectRowAtIndexPath:indexPath animated:NO];
    [_songsTableView.delegate tableView:_songsTableView didDeselectRowAtIndexPath:indexPath];

}



/*
  * Sets if the user is scrubbing right now
  * to avoid slider update while dragging the slider
  */
- (IBAction)userIsScrubbing:(id)sender {
    self.scrubbing = TRUE;
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{

}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{

}

-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{

}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player{

}

- (IBAction)RestorePayment:(id)sender {
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable)
    {
        [_activityIndicator startAnimating];
        [IAPHelper restorePurchases:_activityIndicator :_mRestoreBtn];
        
    }
    

}
-(void)checkForPurMadeButNotReflected{
    
}
#pragma mark - UITableView delegate and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(mainAF.count){
        return [mainAF count];
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mainAF[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0)
    {
        if(indexPath.section==0)
            return 46;
        return 56;
    }
        return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    //if (cell == nil) {
        SongTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SongTableViewCell" owner:nil options:nil] objectAtIndex: 0];
     SongTableViewCellTitle *cellTitle = [[[NSBundle mainBundle] loadNibNamed:@"SongTableViewCellTitle" owner:nil options:nil] objectAtIndex: 0];
    //}
    if(indexPath.row==0){
        
        NSMutableDictionary *attrsDictionary = [NSMutableDictionary dictionary];
        attrsDictionary[NSFontAttributeName] =[UIFont fontWithName:@"Optima-Bold" size:24];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:mainAF[indexPath.section][0] attributes:attrsDictionary];
        
        [cellTitle.titleHeader setAttributedText:attrString];
        [cellTitle setBackgroundColor:[UIColor clearColor]];
        cellTitle.userInteractionEnabled=false;
        return cellTitle;
    }
    
    
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *nameString;

    [cell.timeLabel setText:mainAF[indexPath.section][indexPath.row][@"length"]];
    NSString *price;
    
//    if([mainAF[indexPath.section][indexPath.row][@"access"] isEqualToString:@"paid"])
//    {
//        //check here if its purchased by checking the nsuserdefaults if it isnt , then display a lock else show play and pause like the outer else
//        BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:mainAF[indexPath.section][indexPath.row][@"productID"]];
//            NSLog(@"ahuh %@ = %d", mainAF[indexPath.section][indexPath.row][@"productID"] ,  productPurchased );
//            if (!productPurchased)
//            {
//                UIImage * btnImage1 = [UIImage imageNamed:@"btnGreyPlay"];
//                UIImage * btnImage2 = [UIImage imageNamed:@"btn_lock"];
//
//                [cell.btnLock setImage:btnImage2];
//                [cell.btnPlay setImage:btnImage1];
//
//                NSString *string = mainAF[indexPath.section][indexPath.row][@"productID"];
//                if ([string containsString:@"song"]) {
//                    price = @"17 DKK";
//                    nameString = [NSString stringWithFormat:@"%@ 17 DKK\nmed %@",mainAF[indexPath.section][indexPath.row][@"title"],mainAF[indexPath.section][indexPath.row][@"name"]];
//
//                } else {
//                    nameString = [NSString stringWithFormat:@"%@ 59 DKK\nmed %@",mainAF[indexPath.section][indexPath.row][@"title"],mainAF[indexPath.section][indexPath.row][@"name"]];
//                    price = @"59 DKK";
//
//                }
//
//            }
//            else
//            {
//                NSString *checker = [NSString stringWithFormat:@"%ld-%ld",indexPath.section,indexPath.row];
//                if ([checker isEqualToString:selected]) {
//                    UIImage * btnImage1 = [UIImage imageNamed:@"btn_pause"];
//
//                    [cell.btnLock setImage:nil];
//                    [cell.btnPlay setImage:btnImage1];
//
//                } else {
//                    UIImage * btnImage1 = [UIImage imageNamed:@"btn_play"];
//
//                    [cell.btnLock setImage:nil];
//                    [cell.btnPlay setImage:btnImage1];
//
//                }
//                nameString = [NSString stringWithFormat:@"%@\nmed %@",mainAF[indexPath.section][indexPath.row][@"title"],mainAF[indexPath.section][indexPath.row][@"name"]];
//            }
//    }else{
        
        NSString *checker = [NSString stringWithFormat:@"%ld-%ld",indexPath.section,indexPath.row];
        if ([checker isEqualToString:selected]) {
            UIImage * btnImage1 = [UIImage imageNamed:@"btn_play"];
            
            [cell.btnLock setImage:nil];
            [cell.btnPlay setImage:btnImage1];
            
        } else {
            UIImage * btnImage1 = [UIImage imageNamed:@"btn_play"];
            
            [cell.btnLock setImage:nil];
            [cell.btnPlay setImage:btnImage1];
            
        }
    NSString *contentType = mainAF[indexPath.section][indexPath.row][@"type"];
    if([contentType isEqualToString:@"audio"]) {
        nameString = [NSString stringWithFormat:@"%@\nLyd\nmed %@",mainAF[indexPath.section][indexPath.row][@"title"],mainAF[indexPath.section][indexPath.row][@"name"]];
        [cell.imgMediaType setImage:[UIImage imageNamed:@"volume"]];
    } else {
        nameString = [NSString stringWithFormat:@"%@\nVideo\nmed %@",mainAF[indexPath.section][indexPath.row][@"title"],mainAF[indexPath.section][indexPath.row][@"name"]];
        [cell.imgMediaType setImage:[UIImage imageNamed:@"video"]];
    }
        
        
//    }
    
    NSMutableAttributedString *yourAttributedString = [[NSMutableAttributedString alloc] initWithString:nameString];
    NSString *boldString = mainAF[indexPath.section][indexPath.row][@"title"];
    NSRange boldRange = [nameString rangeOfString:boldString];
    //        [yourAttributedString addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:boldRange];
    [yourAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Optima-Bold" size:17] range:boldRange];
    if([price length]){
        NSRange smallFont = [nameString rangeOfString:price];
        [yourAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Optima" size:12] range:smallFont];
    }
    [cell.lblSongTitle setAttributedText:yourAttributedString];
    
//        }

    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BOOL fileExists = false;
    BOOL isDownloaded = false;
    NSString *type;
    if([mainAF[indexPath.section][indexPath.row][@"type"] isEqualToString:@"audio"])
        type = @"mp3";
    else
        type = @"mp4";
    
    
    //For paid check if its purchasd or not and do the necesaary
//    if([mainAF[indexPath.section][indexPath.row][@"access"] isEqualToString:@"paid"])
//    {
//        //check herer in nsuserdefaults
//        NSString *productId =mainAF[indexPath.section][indexPath.row][@"productID"];
//
//        BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productId];
//        if (!productPurchased)
//        {
//            for(int i= 0; i< [_products count]; i++)
//            {
//                SKProduct *product = [_products objectAtIndex:i];
//                if ([product.productIdentifier isEqualToString:productId])
//                {
//                    NSLog(@"Buying %@...", product.productIdentifier);
//                    [[SongsIAPHelper sharedInstance] buyProduct:product];
//
//                }
//            }
//            NSLog(@"Snehal Test -> should have been purchasing ");
//            [_songsTableView deselectRowAtIndexPath:indexPath animated:YES];
//            [tableView.delegate tableView:_songsTableView didDeselectRowAtIndexPath:indexPath];
//            return;
//        }
//
//    }
    
   
    
    //for songs on select play the song and on deselect stop the song which is playing which means stop the audio player
    
    //for video on select play the video and immediately call diddeselect so that it display the play button immediately

    

    if([type isEqualToString:@"mp3"]){
        //do necessary for audio
        
        //here do the checks for audioplayer currplaying or nah and all

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask,
                                                             YES);
        NSString *fullPath = [[paths.firstObject
                               stringByAppendingPathComponent:mainAF[indexPath.section][indexPath.row][@"title"]]
                              stringByAppendingPathExtension:type];
         fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fullPath];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         isDownloaded = [defaults boolForKey:[NSString stringWithFormat:@"Downloaded-%@",mainAF[indexPath.section][indexPath.row][@"title"]]];

        if (fileExists && isDownloaded) {

//            NSError *error=nil;
[self playTheVideo:fullPath indexP:indexPath];
//            _audioPlayer = [[AVAudioPlayer alloc]
//                            initWithContentsOfURL:[NSURL fileURLWithPath:fullPath]
//                            error:&error];
//            [_audioPlayer prepareToPlay];
//            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//            [[AVAudioSession sharedInstance] setActive: YES error: nil];
//            [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//             [_audioPlayer play];

        } else {
            //
            
            if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable)
            {
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:mainAF[indexPath.section][indexPath.row][@"url"]]];
                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:fullPath append:NO]];
                HUD = [[M13ProgressHUD alloc] initWithProgressView:[[M13ProgressViewRing alloc] init]];
                HUD.progressViewSize = CGSizeMake(60.0, 60.0);
                HUD.animationPoint = self.view.center;
                [HUD setProgress:0.0f animated:NO];
                HUD.status = [NSString stringWithFormat:@"Downloading %@",mainAF[indexPath.section][indexPath.row][@"title"]];
                [self.view addSubview:HUD];
                [HUD show:YES];
                [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                    [HUD setProgress:(float)totalBytesRead / (float)totalBytesExpectedToRead animated:NO];
                    //            NSLog(@"Percent : %f bytesRead: %lu, totalBytesRead: %lld, totalBytesExpectedToRead: %lld", (float)totalBytesRead / (float)totalBytesExpectedToRead,(unsigned long)bytesRead, totalBytesRead, totalBytesExpectedToRead);
                    
                }];
                
                [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSLog(@"RES: %@", [[[operation response] allHeaderFields] description]);
                    [HUD hide:YES];
                    
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setBool:YES forKey:[NSString stringWithFormat:@"Downloaded-%@",mainAF[indexPath.section][indexPath.row][@"title"]]];
                    
                    //play song here
//                    NSError *error=nil;
                    [self playTheVideo:fullPath indexP:indexPath];
//                    _audioPlayer = [[AVAudioPlayer alloc]
//                                    initWithContentsOfURL:[NSURL fileURLWithPath:fullPath]
//                                    error:&error];
//                    [_audioPlayer prepareToPlay];
//                    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//                    [[AVAudioSession sharedInstance] setActive: YES error: nil];
//                    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//                    [_audioPlayer play];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"ERR: %@", [error description]);
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                }];
                
                [operation start];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"No Connection Available"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
          
        }


    }
    else{
        //do necessary for video
        [_audioPlayer pause];
        [self.timer invalidate];

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask,
                                                             YES);
        NSString *fullPath = [[paths.firstObject
                               stringByAppendingPathComponent:mainAF[indexPath.section][indexPath.row][@"title"]]
                              stringByAppendingPathExtension:type];
         fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fullPath];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         isDownloaded = [defaults boolForKey:[NSString stringWithFormat:@"Downloaded-%@",mainAF[indexPath.section][indexPath.row][@"title"]]];
        //manually make it pause so that it doesnt dislay pause after video is done
//        [_songsTableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];

        if (fileExists && isDownloaded) {
            [self playTheVideo:fullPath indexP:indexPath];

        } else {
            
            //
            if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable)
            {
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:mainAF[indexPath.section][indexPath.row][@"url"]]];
                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:fullPath append:NO]];
                HUD = [[M13ProgressHUD alloc] initWithProgressView:[[M13ProgressViewRing alloc] init]];
                HUD.progressViewSize = CGSizeMake(60.0, 60.0);
                HUD.animationPoint = self.view.center;
                [HUD setProgress:0.0f animated:NO];
                HUD.status = [NSString stringWithFormat:@"Downloading %@",mainAF[indexPath.section][indexPath.row][@"title"]];
                [self.view addSubview:HUD];
                [HUD show:YES];
                [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                    [HUD setProgress:(float)totalBytesRead / (float)totalBytesExpectedToRead animated:NO];
                    //            NSLog(@"Percent : %f bytesRead: %lu, totalBytesRead: %lld, totalBytesExpectedToRead: %lld", (float)totalBytesRead / (float)totalBytesExpectedToRead,(unsigned long)bytesRead, totalBytesRead, totalBytesExpectedToRead);
                    
                }];
                
                [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSLog(@"RES: %@", [[[operation response] allHeaderFields] description]);
                    [HUD hide:YES];
                    
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setBool:YES forKey:[NSString stringWithFormat:@"Downloaded-%@",mainAF[indexPath.section][indexPath.row][@"title"]]];
                    
                    [self playTheVideo:fullPath indexP:indexPath];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"ERR: %@", [error description]);
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                }];
                
                [operation start];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"No Connection Available"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            

            
        }
}
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]!=NotReachable)
    {
        if([type isEqualToString:@"mp3"]){
            selected = [NSString stringWithFormat:@"%ld-%ld",indexPath.section,indexPath.row];
            NSLog(@" SELECT -> %@",indexPath);
        }
       
        NSIndexPath *ipath = [_songsTableView indexPathForSelectedRow];
        [_songsTableView reloadData];
        [_songsTableView selectRowAtIndexPath:ipath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }else{
        if (fileExists && isDownloaded){
            if([type isEqualToString:@"mp3"]){
                selected = [NSString stringWithFormat:@"%ld-%ld",indexPath.section,indexPath.row];
                NSLog(@" SELECT -> %@",indexPath);
            }
            
            NSIndexPath *ipath = [_songsTableView indexPathForSelectedRow];
            [_songsTableView reloadData];
            [_songsTableView selectRowAtIndexPath:ipath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }else{
            NSIndexPath *ipath = [_songsTableView indexPathForSelectedRow];
            [_songsTableView reloadData];
        }
    }
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    selected = @"0-0";
    [_audioPlayer pause];
    [self.timer invalidate];
    NSLog(@" DESELECT -> %@",indexPath);
    NSIndexPath *ipath = [_songsTableView indexPathForSelectedRow];
    [_songsTableView reloadData];
    [_songsTableView selectRowAtIndexPath:ipath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isSelected]) {
        // Deselect manually.
        [_songsTableView deselectRowAtIndexPath:indexPath animated:YES];
        [tableView.delegate tableView:_songsTableView didDeselectRowAtIndexPath:indexPath];
        
        return nil;
    }
    
    return indexPath;
}
#pragma Methods for facilating caching
-(void)createHeadingEntry:(NSString*)headingText{
    
    Headings *h =[_appDelegate createHeading];
    
    h.page = 1;
    h.heading = headingText;
    
    [_appDelegate saveContext];
    
    
}
-(void)createProgEntry:(NSData *)data{
    
    Programmer *h =[_appDelegate createProgrammer];
    
    h.data = data;
    
    [_appDelegate saveContext];
    
    
}

-(NSString*)makeHeadingFromCoreData{
    //    NSManagedObjectContext *context = self.appDelegate.persistentContainer.viewContext;
    NSManagedObjectContext *context = [self.appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Headings"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects == nil) {
        NSLog(@"Error fetching details");
        abort();
        
    }
    NSString *heading = @"";
    for(Headings *h in fetchedObjects){
        if(h.page == 1){
            heading = h.heading;
        }
    }
    
    return heading;
}

-(NSData*)makeProgFromCoreData{
    //    NSManagedObjectContext *context = self.appDelegate.persistentContainer.viewContext;
    NSManagedObjectContext *context = [self.appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Programmer"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects == nil) {
        NSLog(@"Error fetching details");
        abort();
        
    }
    NSData *data = nil;
    for(Programmer *h in fetchedObjects){
        data = h.data;
    }
    
    return data;
}
-(void)dataDeleteHeading1{
    //    NSManagedObjectContext *context = self.appDelegate.persistentContainer.viewContext;
    NSManagedObjectContext *context = [self.appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Headings"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for(Headings *a in fetchedObjects)
    {
        if(a.page==1){
            NSManagedObject *aManagedObject = a;
            NSManagedObjectContext *context = [aManagedObject managedObjectContext];
            [context deleteObject:aManagedObject];
            NSError *error;
            if (![context save:&error]) {
                // Handle the error.
            }
        }
        
    }
}
-(void)dataDeleteProg{

    NSManagedObjectContext *context = [self.appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Programmer"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for(Programmer *a in fetchedObjects)
    {
            NSManagedObject *aManagedObject = a;
            NSManagedObjectContext *context = [aManagedObject managedObjectContext];
            [context deleteObject:aManagedObject];
            NSError *error;
            if (![context save:&error]) {
                // Handle the error.
            }
    }
}


@end
