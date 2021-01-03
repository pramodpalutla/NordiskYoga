

#import "aboutNorYo.h"
#import "AFNetworking.h"
#import "profData.h"
#import "profImage.h"
#import "profImageWithoutName.h"
#import "About+CoreDataClass.h"
#import "Headings+CoreDataClass.h"
#import "AppDelegate.h"

@interface aboutNorYo ()
@property (strong, nonatomic) IBOutlet UIView *superView;

@end

@implementation aboutNorYo{
    NSMutableArray *dataArr;
    NSMutableArray *result;

    dispatch_group_t serviceGroup;
    dispatch_group_t serviceGroup1;

    dispatch_group_t imGroup;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
//    [self scrollViewDidScroll:self.tbView];

    dataArr = [[NSMutableArray alloc]init];
    result  = [[NSMutableArray alloc]init];
    _tbView.dataSource = self;
    _tbView.delegate = self;
    _tbView.separatorColor=[UIColor clearColor];
   
    _tbView.allowsSelection=YES;
    serviceGroup = dispatch_group_create();
    serviceGroup1 = dispatch_group_create();
    _activityIndicator.hidesWhenStopped = YES;
    imGroup = dispatch_group_create();
    
    [_activityIndicator startAnimating];
    [self getHeading];
    [self getData];

    
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
    

    // Do any additional setup after loading the view.
}

-(void)getHeading{
    __block NSArray *result = [[NSArray alloc]init];
    [_activityIndicator startAnimating];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.nordiskyoga.dk/api/headings"]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *err = nil;
        id data = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:&err];
        if([data[@"error"] isEqual:@(1)]){
            NSArray *resData = data[@"result"];
            result = resData;
        }
        [self dataDeleteHeading4];
        for (int i=0; i<[result count]; i++) {
            NSDictionary *temp = result[i];
            if([temp[@"type"] isEqualToString:@"about_nordisk"]){
                
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


-(void)getData{
    
    //below two errors are to display cache
    
   __block NSError *er1 = nil;
   __block NSError *er2 = nil;

    
    //GETTING ADMINS
    __block NSArray *result = [[NSArray alloc]init];
    __block NSArray *result1 = [[NSArray alloc]init];

    dispatch_group_enter(serviceGroup);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.nordiskyoga.dk/api/admins"]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *err = nil;
        id data = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:&err];
        if([data[@"error"] isEqual:@(1)]){
            NSArray *resData = data[@"result"];
//            NSLog(@"the no of admins are %d",[resData count]);
            //            NSLog(@"VIVI DATA %@",resData[0]);
            //            NSLog(@"MARIA DATA %@",resData[1]);
            result = resData;
//            NSLog(@"%@",result);

            
        }
        dispatch_group_leave(serviceGroup);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        er1 = error;
        NSLog(@"ERR: %@", [error description]);
        //below is test so remove it
        dispatch_group_leave(serviceGroup);

    }];
    
    //GETTING NY ABOUT
    
    dispatch_group_enter(serviceGroup);
    NSURLRequest *request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.nordiskyoga.dk/api/description"]];
    AFHTTPRequestOperation *operation1 = [[AFHTTPRequestOperation alloc] initWithRequest:request1];
    [operation1 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *err = nil;
        id data = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:&err];
        if([data[@"error"] isEqual:@(1)]){
            NSArray *resData = data[@"result"];
            result1 = resData;
        }
        dispatch_group_leave(serviceGroup);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        er2 = error;
        NSLog(@"ERR: %@", [error description]);
        //below is test so remove it
        dispatch_group_leave(serviceGroup);

        
    }];
    
    [operation start];

    [operation1 start];
    
    
    
    dispatch_group_notify(serviceGroup,dispatch_get_main_queue(),^{
        
        if(er1||er2){
            dataArr = [self makeDataArrFromCoreData];
            [_tbView reloadData];
            [_activityIndicator stopAnimating];

            
        }
        else{
            //everytime it enters here it means internet is available and everytime the old coreD must be deleted and updated
            
            [self dataDeleteAbout];
            
            for (int i = 0 ; i<[result count] ; i ++){
                NSDictionary *tempArray =result[i];
                NSString *link = tempArray[@"image"];
                UIImage *image = [self getImage:link];
                NSString *adminName = tempArray[@"name"];
                NSString *desc = tempArray[@"desc"];
                [self createAboutEntry:image name:adminName desc:desc];
                NSArray *arr = [[NSArray alloc] initWithObjects:image,desc,adminName,nil];
                [dataArr addObject:arr];

            }
            NSDictionary *tempArray1 =result1[1];
            NSString *desc = tempArray1[@"description"];
            UIImage *image = [UIImage imageNamed:@"nyAboutNew.png"];
            [self createAboutEntry:image name:@"" desc:desc];

            NSArray *arr = [[NSArray alloc] initWithObjects:image,desc,@"",nil];
            [dataArr addObject:arr];

        }
        
        
        
        
        [_tbView reloadData];
        [_activityIndicator stopAnimating];
        
        return;
    });

}


-(UIImage *)getImage:(NSString*)link{
    NSData * imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:link]];
    UIImage *im = [UIImage imageWithData:imageData];
    return im;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma dataource for table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [dataArr count];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   if(indexPath.row==0)
   {
       if((indexPath.section+1) == [dataArr count])
           return 140;
        return 183;

   }
   else
        return UITableViewAutomaticDimension;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *datCell = @"profData";
    static NSString *imCell = @"profImage";
    static NSString *imCellWithoutLabel = @"profImageWithout";



    profData *dataCell = (profData *) [tableView dequeueReusableCellWithIdentifier:datCell];
    profImage *imageCell = (profImage *) [tableView dequeueReusableCellWithIdentifier:imCell];
    profImageWithoutName *imageCellWithoutName = (profImageWithoutName *) [tableView dequeueReusableCellWithIdentifier:imCellWithoutLabel];
    
    //if (cell == nil) {
    dataCell = [[[NSBundle mainBundle] loadNibNamed:@"profData" owner:nil options:nil] objectAtIndex: 0];
    imageCell = [[[NSBundle mainBundle] loadNibNamed:@"profImage" owner:nil options:nil] objectAtIndex: 0];
    imageCellWithoutName = [[[NSBundle mainBundle] loadNibNamed:@"profImageWithoutName" owner:nil options:nil] objectAtIndex: 0];
    imageCell.selectionStyle = UITableViewCellSelectionStyleNone;
    dataCell.selectionStyle = UITableViewCellSelectionStyleNone;
    imageCellWithoutName.selectionStyle = UITableViewCellSelectionStyleNone;


    //}
    NSArray *d = dataArr[indexPath.section];
    
    if(indexPath.row==0){
        
        if((indexPath.section+1) == [dataArr count]){
            imageCellWithoutName.profImage.image = d[0];
        }
        else{
            imageCell.profImage.image = d[0];
            NSMutableDictionary *attrsDictionary = [NSMutableDictionary dictionary];
            attrsDictionary[NSFontAttributeName] =[UIFont fontWithName:@"Optima-Bold" size:24];
            NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:d[2] attributes:attrsDictionary];
            imageCell.nameLabel.attributedText=attrString;
        }
    }else{
        
        NSMutableAttributedString* attrString = [[NSMutableAttributedString  alloc] initWithString:[NSString stringWithFormat:@"%@\n\n",d[1]]];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//        [style setLineSpacing:2];
        [attrString addAttribute:NSParagraphStyleAttributeName
                           value:style
                           range:NSMakeRange(0, [d[1] length])];
        dataCell.descLabel.attributedText = attrString;
    }
    
    if(indexPath.row==0){
        if((indexPath.section+1) == [dataArr count])
            return imageCellWithoutName;
        
        return imageCell;
    }
    else
        return dataCell;
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

#pragma Methods for facilating caching
-(void)createHeadingEntry:(NSString*)headingText{
    
    Headings *h =[_appDelegate createHeading];
    
    h.page = 4;
    h.heading = headingText;
    
    [_appDelegate saveContext];

    
}

-(void)createAboutEntry:(UIImage*)image name:(NSString*)name desc:(NSString*)desc{
    NSData *imageData = UIImagePNGRepresentation(image);
    
    About *a =[_appDelegate createAbout];
    
    a.image = imageData;
    a.text = desc;
    a.name = name;
    
    [_appDelegate saveContext];
    
}
-(NSArray*)makeDataArrFromCoreData{
    NSManagedObjectContext *context = [self.appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"About"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects == nil) {
        NSLog(@"Error fetching details");
        abort();
        
    }
    NSMutableArray *data=[NSMutableArray arrayWithArray:@[]];
    
    for(About *a in fetchedObjects){
        NSArray *arr = [[NSArray alloc] initWithObjects:[UIImage imageWithData:a.image],a.text,a.name,nil];
        [data addObject:arr];
    }
    
    return data;
    
}
-(NSString*)makeHeadingFromCoreData{
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
        if(h.page == 4){
            heading = h.heading;
        }
    }
    
    return heading;
}
-(void)dataDeleteAbout{
    NSManagedObjectContext *context = [self.appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"About"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for(About *a in fetchedObjects)
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
-(void)dataDeleteHeading4{
    NSManagedObjectContext *context = [self.appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Headings"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for(Headings *a in fetchedObjects)
    {
        if(a.page==4){
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

@end
