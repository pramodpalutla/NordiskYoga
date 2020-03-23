

#import "BioViewController.h"
#import "AFNetworking.h"
#import "tvUgeCell.h"
#import "tvCourseCell.h"
#import "tvUgeDayDateCell.h"
#import "Ugeplan+CoreDataClass.h"
#import "Headings+CoreDataClass.h"
@interface BioViewController ()
@property (strong, nonatomic) IBOutlet UIView *superView;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation BioViewController{
    NSInteger pageCount;
    NSString *nextLink;
    NSString *nextString;
    NSString *prevLink;
    NSString *prevString;
    __block NSMutableArray *result;
    NSDictionary *engToDanDays;
    NSMutableArray *mainArray;
    BOOL ip;
}

- (void)viewDidLoad {
    [super viewDidLoad];
[_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://nordiskyoga.dk"]]];    _nextButton.titleLabel.text = @"";
    pageCount = 0;
    self.appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    _ugView.delegate = self;
    _ugView.dataSource = self;
    _ugView.separatorColor=[UIColor clearColor];
    _ugView.allowsSelection=true;
    _prevButton.enabled = false;
    mainArray = [[NSMutableArray alloc]init];
    _activityIndicator.hidesWhenStopped = YES;
    [_activityIndicator startAnimating];
    [self getHeading];
    [self getData:@"http://api.nordiskyoga.dk/ugeplan-website.php"];
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
    
    // get your window screen size
    //create a new view with the same size
    UIImageView *v = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"whiteBar.png"]];
    [v setFrame:CGRectMake(0, 0, screenWidth, 100)];
    [_ugView addSubview:v];
//    NSLog(@"%@",_ugView.subviews);


}
- (IBAction)nextButtonPressed:(id)sender {
    [_activityIndicator startAnimating];
    _nextButton.enabled = false;
    pageCount = pageCount + 1;
    mainArray = [[NSMutableArray alloc]init];
    [_ugView reloadData];
    [self getData:nextLink];
    //for now this but it has to change to `nextLink`
    
}
- (IBAction)prevButtonPressed:(id)sender {
    [_activityIndicator startAnimating];
    _prevButton.enabled = false;
    pageCount = pageCount - 1;
    mainArray = [[NSMutableArray alloc]init];
    [_ugView reloadData];
    [self getData:prevLink];
    
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
        [self dataDeleteHeading3];

        for (int i=0; i<[result count]; i++) {
            NSDictionary *temp = result[i];
            if([temp[@"type"] isEqualToString:@"ugeplan"]){

                [self createHeadingEntry:temp[@"text"]];
                NSMutableDictionary *attrsDictionary = [NSMutableDictionary dictionary];
                
                if([[[UIDevice currentDevice] model] isEqualToString:@"iPad"])
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


-(void)getData:(NSString*)link{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:link]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *err = nil;
        id data = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:&err];
                [self dataDeleteUgeplanForID:pageCount];
        if([data[@"error"] isEqual:@(1)]){
            NSDictionary *resData = data[@"result"];
            nextLink =[data[@"next"] stringByRemovingPercentEncoding] ;
            nextString=data[@"next_heading"];
            prevLink = data[@"last"];
            prevString = data[@"last_heading"];

            NSMutableArray *main = [[NSMutableArray alloc]init];
            for(NSString *index in resData){
                NSDictionary *res = resData[index];
                NSMutableArray *temp = [[NSMutableArray alloc]init];
                [temp addObject:res[@"heading"]];
                for ( NSDictionary *temp1 in res[@"data"]){
                    NSArray *dayDateGray = [NSArray arrayWithObjects:temp1[@"weekday"],temp1[@"gray"],nil];
                    [temp addObject:dayDateGray];
                    for (NSDictionary *temp2 in temp1[@"data"]){
                        
                        NSString *t = [NSString stringWithFormat:@"Kl. %@",temp2[@"time"]];
                        NSString *myString = temp2[@"text"];
                        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
                        [style setLineHeightMultiple:0.85];
                        NSDictionary *attributes = @{
                                                     NSParagraphStyleAttributeName:style
                                                     };
                        NSAttributedString *attString = [[NSAttributedString alloc]initWithString:myString attributes:attributes];
                        NSAttributedString *attString1 = [[NSAttributedString alloc]initWithString:t attributes:attributes];
                        NSDictionary *tit = @{
                                              @"text":attString,
                                              @"gray":temp2[@"gray"],
                                              @"time":attString1,
                                              @"link":temp2[@"link"]
                                              };
                        
                        [temp addObject:tit];
                }
            }
                [main addObject:temp];
            }
            mainArray = main;
//            NSLog(@"%@",mainArray);
             [self createUgeplanEntryWithData:[NSKeyedArchiver archivedDataWithRootObject:mainArray] next:nextString prev:prevString forId:pageCount];
            
            [_ugView reloadData];
            [_nextButton setTitle:[NSString stringWithFormat:@"%@ >",nextString] forState:UIControlStateNormal] ;
            if(![prevString isEqualToString:@""]){
                [_prevButton setTitle:[NSString stringWithFormat:@"< %@",prevString] forState:UIControlStateNormal];
                _prevButton.enabled = true;
            }else{
                [_prevButton setTitle:@"" forState:UIControlStateNormal];
                _prevButton.enabled = false;
            }
            _nextButton.enabled = true;
            
            NSLog(@"PAGE is %ld",(long)pageCount);
            [_activityIndicator stopAnimating];

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERR: %@", [error description]);
        NSLog(@"ok COMING HERE");

        NSArray *temp = [self getUgeplanForID:pageCount];
        
        if(temp.count){
            NSArray *cachedArray = [NSKeyedUnarchiver unarchiveObjectWithData:temp[0]];
            mainArray = cachedArray;
            [_nextButton setTitle:[NSString stringWithFormat:@"%@ >",temp[1]] forState:UIControlStateNormal] ;
            if(![temp[2] isEqualToString:@""]){
                [_prevButton setTitle:[NSString stringWithFormat:@"< %@",temp[2]] forState:UIControlStateNormal];
                _prevButton.enabled = true;
            }else{
                [_prevButton setTitle:@"" forState:UIControlStateNormal];
                _prevButton.enabled = false;
            }
            if([self getUgeplanForID:pageCount+1].count)
                _nextButton.enabled = true;
            else
                _nextButton.enabled = false;
            [_ugView reloadData];
        }
        [_activityIndicator stopAnimating];

    }];
    [operation start];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma table view delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(mainArray.count)
        return [mainArray count];
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"%ld  %@",(long)section,courseCountInWeek);
    if(mainArray.count)
        return [[mainArray objectAtIndex:section] count];
    else
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {                                                         
    if(indexPath.row==0)
        return 47;
    else
        return 38.7;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ugeCell1 = @"tvUgeCell";
    static NSString *courseCell1 = @"tvCourseCell";
    static NSString *dayDateCell1 = @"tvUgeDayDateCell";

    //if (cell == nil) {
    tvUgeCell *ugeCell = [[[NSBundle mainBundle] loadNibNamed:ugeCell1 owner:nil options:nil] objectAtIndex: 0];
    tvCourseCell *courseCell = [[[NSBundle mainBundle] loadNibNamed:courseCell1 owner:nil options:nil] objectAtIndex: 0];
    tvUgeDayDateCell *dayDateCell = [[[NSBundle mainBundle] loadNibNamed:dayDateCell1 owner:nil options:nil] objectAtIndex: 0];
    
    ugeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    courseCell.selectionStyle = UITableViewCellSelectionStyleNone;
    dayDateCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //}
    
        if(indexPath.row==0){
            ugeCell.ugeHeader.text = mainArray[indexPath.section][indexPath.row];
            ugeCell.userInteractionEnabled=false;
        }else{
            
            if([[[mainArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] count] == 2){
                dayDateCell.dayLabel.text =[[mainArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row][0];
                if([[[mainArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row][1] isEqualToString:@"true"]){
                    dayDateCell.dayLabel.textColor =[UIColor colorWithRed:0.88 green:0.88 blue:0.85 alpha:1.0];
       
                }
                dayDateCell.userInteractionEnabled=false;
  
            }
            else{
                courseCell.courseLabel.attributedText = [[mainArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row][@"text"];
                courseCell.timeLabel.attributedText = [[mainArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row][@"time"];

                if ([[[mainArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row][@"gray"] isEqualToString:@"true"]) {
                    [UIColor colorWithRed:0.88 green:0.88 blue:0.85 alpha:1.0];
                    courseCell.timeLabel.textColor =[UIColor colorWithRed:0.88 green:0.88 blue:0.85 alpha:1.0];
                    courseCell.courseLabel.textColor =[UIColor colorWithRed:0.88 green:0.88 blue:0.85 alpha:1.0];
                }
            }

        }
    
    if(indexPath.row==0)
        return ugeCell;
    else
        if([[[mainArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] count] == 2)
            return dayDateCell;
        else
            return courseCell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(mainArray.count){
        NSString *link = [[mainArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row][@"link"];    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}

#pragma methods to enable core data
-(void)createUgeplanEntryWithData:(NSData*)data next:(NSString*)nextString prev:(NSString*)prevString forId:(long)ID{ //create
    
    Ugeplan *u =[_appDelegate createUgeplan];
    
    u.iD = ID;
    u.next_heading = nextString;
    u.prev_heading = prevString;
    u.data = data;
    
    [_appDelegate saveContext];
    
}
-(NSArray*)getUgeplanForID:(long)ID{  //read
    NSManagedObjectContext *context = [self.appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Ugeplan"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects == nil) {
        NSLog(@"Error fetching details");
        abort();
        
    }
    NSData *new = nil;
    NSString *next_heading = @"";
    NSString *prev_heading = @"";

    for(Ugeplan *u in fetchedObjects){
        if(u.iD == ID){
            new = u.data;
            next_heading = u.next_heading;
            prev_heading = u.prev_heading;
        }
    }
    NSArray *arr = [NSArray arrayWithObjects:new,next_heading,prev_heading,nil];

    return arr;
}
-(void)dataDeleteUgeplanForID:(long)ID{ //delete
    NSManagedObjectContext *context = [self.appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Ugeplan"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for(Ugeplan *u in fetchedObjects)
    {
        if(u.iD == ID){
            NSManagedObject *aManagedObject = u;
            NSManagedObjectContext *context = [aManagedObject managedObjectContext];
            [context deleteObject:aManagedObject];
            NSError *error;
            if (![context save:&error]) {
                // Handle the error.
            }
        }
    }
}
-(void)createHeadingEntry:(NSString*)headingText{
    
    Headings *h =[_appDelegate createHeading];
    
    h.page = 3;
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
        if(h.page == 3){
            heading = h.heading;
        }
    }
    
    return heading;
}
-(void)dataDeleteHeading3{
    NSManagedObjectContext *context = [self.appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Headings"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for(Headings *a in fetchedObjects)
    {
        if(a.page==3){
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
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}



@end
