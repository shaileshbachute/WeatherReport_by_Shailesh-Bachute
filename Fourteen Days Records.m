//
//  Fourteen Days Records.m
//  WeatherInfoApp_by_Shailesh_Bachute
//
//  Created by Alet Viegas on 23/05/14.
//  Copyright (c) 2014 Alet Viegas. All rights reserved.
//

#import "Fourteen Days Records.h"

#import "WeatherCustomeCell.h"      //This Class imported to preapre cells in each row of UITableView

#import "Reachability.h"    //This  class is imported to check the internet connection working or not.



@interface Fourteen_Days_Records ()
{
     dispatch_queue_t queue;    //Here create a queue.
}
@property (weak, nonatomic) IBOutlet UITableView *table;

@end
extern NSMutableString *strCityName;
@implementation Fourteen_Days_Records

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
                                                            //Here allocate memories for all arrays.
    listArray=[[NSMutableArray alloc]init];
    tempratureArray=[[NSMutableArray alloc]init];
    dayTempArray=[[NSMutableArray alloc]init];
    nightTempArray=[[NSMutableArray alloc]init];
    morningTempArray=[[NSMutableArray alloc]init];
    eveningTempArray=[[NSMutableArray alloc]init];
    minTempArray=[[NSMutableArray alloc]init];
    maxTempArray=[[NSMutableArray alloc]init];
    rainArray=[[NSMutableArray alloc]init];
    humidityArray=[[NSMutableArray alloc]init];
    cloudArray=[[NSMutableArray alloc]init];
    objOfAppDelegate=[[AppDelegate alloc]init];
  
    //Activity Indicator
    
    _actLoad=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //actLoad.frame=CGRectMake(110, 110, 150, 130);
    _actLoad.frame=CGRectMake(135, 255, 50, 50);
    _actLoad.backgroundColor=[UIColor blackColor];
    [_actLoad.layer setCornerRadius:11];
    [_actLoad.layer setMasksToBounds:YES];
    _actLoad.alpha=0.7;
    [self.view addSubview:_actLoad];

    queue= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^(void)          //Here we add all parsing process in background queue Asynconously for avoiding the ui blocking problem on main thread.
    {
        [_actLoad startAnimating];          //This method starts animation of acivity indicator.
        [self getWeatherData];
        dispatch_async(dispatch_get_main_queue(), ^(void)       //Get on main thread for refreshing ui contents.
        {
            _table.alpha=0.4;
            [UIView animateWithDuration:0.3 animations:^{  //Animation and alpha values are used to just give fade effect to weather report UITableView.
                _table.alpha=1;
                
            }];

            [_table reloadData];        // Here in main thread refresh contents of uiTableView.
            [_actLoad stopAnimating];
        });
    });

   
}


#pragma mark- This method contains JSON parsing which gives all weather data of entered or assigned city name in First ViewCintroller..

-(void)getWeatherData
{
    objOfAppDelegate=[[UIApplication sharedApplication]delegate];   //This line enables sharing of data in appdelegate file.

    NSString *strUrl=[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?q=%@&mode=json&units=metric&cnt=14",objOfAppDelegate.strCityNameApDel];
    
    // NSURL *url=[NSURL URLWithString:@"http://api.openweathermap.org/data/2.5/forecast/daily?q=solapur&mode=json&units=metric&cnt=1"];
    
    NSURL *url=[NSURL URLWithString:strUrl];
    
    NSHTTPURLResponse *response=nil;
    
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
    
    
    NSData *dataNS=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    
    NSMutableDictionary *result=[NSJSONSerialization JSONObjectWithData:dataNS options:NSJSONReadingMutableContainers error:nil];
    
    
    listArray=[result valueForKey:@"list"];
    tempratureArray=[listArray valueForKey:@"temp"];
    dayTempArray=[tempratureArray valueForKey:@"day"];
    nightTempArray=[tempratureArray valueForKey:@"night"];
    eveningTempArray=[tempratureArray valueForKey:@"eve"];
    morningTempArray=[tempratureArray valueForKey:@"morn"];
    minTempArray=[tempratureArray valueForKey:@"min"];
    maxTempArray=[tempratureArray valueForKey:@"max"];
    
    cloudArray=[listArray valueForKey:@"clouds"];
    humidityArray=[listArray valueForKey:@"humidity"];
    rainArray=[listArray valueForKey:@"rain"];
    
    
    NSArray *city=[[NSArray alloc]init];
    city=[result valueForKey:@"city"];
    strCityName=[city valueForKey:@"name"];
    
    NSLog(@"Result OfAll Data :  %@",result);
//    NSLog(@"Tempratures :  %@",tempratureArray);
//    NSLog(@"Day Temprature :  %@",dayTempArray);
//    NSLog(@"Nigth Temprature :  %@",nightTempArray);
//    NSLog(@"Morning Temprature :  %@",morningTempArray);
//    NSLog(@"Evening Temprature :  %@",eveningTempArray);
//    NSLog(@"Min Temprature :  %@",minTempArray);
//    NSLog(@"Max Temprature :  %@",maxTempArray);
//   
//    NSLog(@"%d",[dayTempArray count]);
//    NSLog(@"%d",[minTempArray count]);
//    NSLog(@"%d",[maxTempArray count]);
//    NSLog(@"%d",[humidityArray count]);
//    NSLog(@"%d",[cloudArray count]);
//    NSLog(@"%d",[rainArray count]);
    
    NSLog(@"Max Temprature :  %@",humidityArray);
    
}


#pragma mark- This is UITableView Data Source method which gives number of rows.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 14;
    
}


#pragma mark- This UITableView Data Source method which preapres cells for every row.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    
    NSString *celID=@"weathercell";     //This is cell identifier which is already assigned in customecell in story board.
    WeatherCustomeCell *cell = (WeatherCustomeCell *)[tableView dequeueReusableCellWithIdentifier:celID]; //Here load custome cell with help of WeatherCustomCell object.
    
    if ([listArray count]==14)      //This condition used to avoid app crash.Because if it Contains less than 14records then it will crash.
    {
        cell.lblCityName.text=strCityName;
        cell.lblCurrentTemp.text=[NSString stringWithFormat:@"%@",[dayTempArray objectAtIndex:indexPath.row]];
        cell.lblMaxTemp.text=[NSString stringWithFormat:@"H: %@",[maxTempArray objectAtIndex:indexPath.row]];
        cell.lblLowTemp.text=[NSString stringWithFormat:@"L: %@",[minTempArray objectAtIndex:indexPath.row]];
        cell.lblHumidity.text=[NSString stringWithFormat:@"Humidity: %@",[humidityArray objectAtIndex:indexPath.row]];
        cell.lblCloud.text=[NSString stringWithFormat:@"%@",[cloudArray objectAtIndex:indexPath.row]];
        cell.lblRain.text=[NSString stringWithFormat:@"%@",[rainArray objectAtIndex:indexPath.row]];
        
        if (indexPath.row==0)          //This for showing todays weather record in table list at first row.
        {
            cell.lblDays.text=@"Today";
        }
        else if (indexPath.row==1)      //Second row contains seocond day weather data i.e. Tomorrow
        {
            cell.lblDays.text=@"Tomorrow";
        }
        else if (indexPath.row>1)
        {
            cell.lblDays.text=[NSString stringWithFormat:@"After %d Days",indexPath.row];
        }
        
    }
    
         return cell;
    
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
