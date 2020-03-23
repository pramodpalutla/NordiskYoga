
#import "ShopViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "Om+CoreDataClass.h"
#import "Headings+CoreDataClass.h"

@interface ShopViewController ()
@property (strong, nonatomic) IBOutlet UIView *superView;

@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];

     self.appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];

    _activityIndicator.hidesWhenStopped = YES;
    
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
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.nordiskyoga.dk/api/headings"]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *err = nil;
        id data = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:&err];
        if([data[@"error"] isEqual:@(1)]){
            NSArray *resData = data[@"result"];
            result = resData;
        }
        [self dataDeleteHeading2];
        for (int i=0; i<[result count]; i++) {
            NSDictionary *temp = result[i];
            if([temp[@"type"] isEqualToString:@"about_yoga"]){
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
    
    __block NSArray *result = [[NSArray alloc]init];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.nordiskyoga.dk/api/description"]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *err = nil;
        id data = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:&err];
        if([data[@"error"] isEqual:@(1)]){
            NSArray *resData = data[@"result"];
            result = resData;
        }
        [self dataDeleteOm];
        NSString *tbViewData =result[0][@"description"];
        [self createOmEntry:result[0][@"description"]];
        [_lblDes setText:tbViewData];
        [_activityIndicator stopAnimating];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERR: %@", [error description]);
        
        [_lblDes setText:[self makeOmFromCoreData]];
        [_activityIndicator stopAnimating];

    }];
    [operation start];

}

#pragma methods to enable core data
-(void)createOmEntry:(NSString*)text{ //create
    Om *o =[_appDelegate createOm];
    
    o.text = text;
    
    [_appDelegate saveContext];
    
}
-(NSString*)makeOmFromCoreData{  //read
    NSManagedObjectContext *context = [self.appDelegate managedObjectContext];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Om"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects == nil) {
        NSLog(@"Error fetching details");
        abort();
        
    }
    NSString *om = @"";
    for(Om *o in fetchedObjects){
        om = o.text;
    }
    
    return om;
}
-(void)dataDeleteOm{ //delete

    NSManagedObjectContext *context = [self.appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Om"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for(Om *om in fetchedObjects)
    {
        NSManagedObject *aManagedObject = om;
        NSManagedObjectContext *context = [aManagedObject managedObjectContext];
        [context deleteObject:aManagedObject];
        NSError *error;
        if (![context save:&error]) {
            // Handle the error.
        }
    }
}
-(void)createHeadingEntry:(NSString*)headingText{
    
    Headings *h =[_appDelegate createHeading];
    
    h.page = 2;
    h.heading = headingText;
    
    [_appDelegate saveContext];
    
    
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
        if(h.page == 2){
            heading = h.heading;
        }
    }
    
    return heading;
}
-(void)dataDeleteHeading2{
    NSManagedObjectContext *context = [self.appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Headings"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for(Headings *a in fetchedObjects)
    {
        if(a.page==2){
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
