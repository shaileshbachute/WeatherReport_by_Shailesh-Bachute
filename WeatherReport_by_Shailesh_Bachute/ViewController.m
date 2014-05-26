//
//  ViewController.m
//  WeatherReport_by_Shailesh_Bachute
//
//  Created by SHAILESH SHANKAR BACHUTE on 24/05/14.
//  Copyright (c) 2014 SHAILESH SHANKAR BACHUTE. All rights reserved.
//


#import "ViewController.h"

#import "Fourteen Days Records.h"

#import "Reachability.h"                //This  class is imported to check the internet connection working or not.


@interface ViewController ()
{
    dispatch_queue_t queue;        //Here create a queue.
}

@property (weak, nonatomic) IBOutlet UIView *viewWeatherReport;       //Button for get parsed weather data.
@property (weak, nonatomic) IBOutlet UIButton *btnCurrenLocationData; //Button to get current location.
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    listArray=[[NSMutableArray alloc]init];             //Here allocate memories for all arrays.
    tempratureArray=[[NSMutableArray alloc]init];
    dayTempArray=[[NSMutableArray alloc]init];
    nightTempArray=[[NSMutableArray alloc]init];
    morningTempArray=[[NSMutableArray alloc]init];
    eveningTempArray=[[NSMutableArray alloc]init];
    minTempArray=[[NSMutableArray alloc]init];
    maxTempArray=[[NSMutableArray alloc]init];
    objOfAppDelegate=[[AppDelegate alloc]init];
    
    
//Create Activity Indicator
    
    _actLoad=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //actLoad.frame=CGRectMake(110, 110, 150, 130);
    _actLoad.frame=CGRectMake(135, 45, 50, 50);
    _actLoad.backgroundColor=[UIColor blackColor];
    [_actLoad.layer setCornerRadius:11];
    [_actLoad.layer setMasksToBounds:YES];
    _actLoad.alpha=0.7;
    [_viewWeatherReport addSubview:_actLoad];
    
    _viewWeatherReport.frame=CGRectMake(0, 568, 322, 216);    //Set frame initially to bottom.
    _viewWeatherReport.hidden=TRUE;
    
    
    UITapGestureRecognizer *tapRecg=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tapRecg];                                                                           //Adding tap gesture on view for the use of disappearing key board.
    
    
}

#pragma mark- This method will executed when user taps on screen.

-(void)tapAction
{
    [_txtCity endEditing:YES];  //Here keybord is disappearing.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- This is 'Get Weather Details' button action method to get weather report of user entered city in UITextFiled.

- (IBAction)GetData:(id)sender
{
    
    [_txtCity endEditing:YES];                                 //This will disappears keyboard
    if ([_txtCity.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Sorry !" message: @"Please Enter City Name" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    else
    {
        
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];              //Here we get status of network connection i.e.not reachable or reachable.
        
        if (networkStatus == NotReachable)
        {
            UIAlertView *networkAlert= [[UIAlertView alloc]initWithTitle:@"Network Alert" message:@"Please Connect to Internet To access this Service " delegate:Nil cancelButtonTitle:@"ok" otherButtonTitles:Nil, nil];       //Alert will be show with message to check network connection.
            [networkAlert show];
        }
        else
        {
            [_actLoad startAnimating];              //This method starts animation of acivity indicator.
            
            [self startAnimation];                  //This method starts animation of wearher report uiview.
            
            queue= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            
            dispatch_async(queue, ^(void)           //Here we add all parsing process in background queue Asynconously for avoiding the ui blocking problem on main thread.
                   {
                       
                       [self getWeatherData];    //Call to fuction for parsing.
                       
                       
                       dispatch_async(dispatch_get_main_queue(), ^(void)       //Get on main thread for refreshing ui contents.
                                      {
                                          if ([listArray count]==0)             // If no data availble after parsing then show the alert.
                                          {
                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Sorry !" message: @"No Weather Recods Found.\nPlease try again.\nOR\nPlease Check city name." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                              [alert show];
                                              
                                          }
                                          
                                          [UIView animateWithDuration:0.3 animations:^{   //Animation and alpha values are used to just give fade effect to weather report view.
                                              _viewWeatherReport.alpha=0;
                                              _viewWeatherReport.alpha=1;
                                              
                                          }];
                                          
                                                                            // Here in main thread refresh all contents of ui which is already set in background parsing function.
                                          [_lblCityName setNeedsDisplay];
                                          [_lblMaxTemp setNeedsDisplay];
                                          [_lblLowTemp setNeedsDisplay];
                                          [_lblHumidity setNeedsDisplay];
                                          [_lblCloud setNeedsDisplay];
                                          [_lblRain setNeedsDisplay];
                                          [_lblCurrentTemp setNeedsDisplay];
                                          
                                          [_actLoad stopAnimating];         //Stop the animation of activity indicator.
                                          
                                      });
                   });
  
        }
    }
    
}

#pragma mark- This method used to animate Weather report UIView.

-(void)startAnimation
{
    _viewWeatherReport.hidden=FALSE;
    
    [UIView animateWithDuration:0.4 animations:^{               //This method shows animation from source frams to destination frame.
        
        _viewWeatherReport.frame=CGRectMake(0, 246, 322, 216); //Here we set weather report view to required position
        
    }];
    
    
}


#pragma mark- This method contains JSON parsing which gives all weather data of entered city name.

-(void)getWeatherData
{
    
    objOfAppDelegate=[[UIApplication sharedApplication]delegate];   //This line enables sharing of data in appdelegate file.
    
    objOfAppDelegate.strCityNameApDel=[NSMutableString stringWithFormat:@"%@",_txtCity.text]; //Access the city name string in appdelegate file whith the help of object of appdelegate and assign value of UITextfiled City name to it.
    
    NSString *strUrl=[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?q=%@&mode=json&units=metric&cnt=1",_txtCity.text];   // This url gives all weather data in json format by using City Name.
    
    
    // NSURL *url=[NSURL URLWithString:@"http://api.openweathermap.org/data/2.5/forecast/daily?q=solapur&mode=json&units=metric&cnt=1"];
    
    NSURL *url=[NSURL URLWithString:strUrl];  // Here get string in the url form.
    
    NSHTTPURLResponse *response=nil;
    
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];  //Here we request that url.
    
    
    NSData *dataNS=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    
    NSMutableDictionary *result=[NSJSONSerialization JSONObjectWithData:dataNS options:NSJSONReadingMutableContainers error:nil];           // Here parsed data stores in result in form of dictionary.
    

                                                     //Now one by one required data stored in respective array.
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
    
    
    //    NSLog(@"Result OfAll Data :  %@",result);
    //    NSLog(@"Tempratures :  %@",tempratureArray);
    //    NSLog(@"Day Temprature :  %@",dayTempArray);
    //    NSLog(@"Nigth Temprature :  %@",nightTempArray);
    //    NSLog(@"Morning Temprature :  %@",morningTempArray);
    //    NSLog(@"Evening Temprature :  %@",eveningTempArray);
    //    NSLog(@"Min Temprature :  %@",minTempArray);
    //    NSLog(@"Max Temprature :  %@",strMaxTemp);
    
    
                                                //Setting all UILable texts one by one
    _lblCityName.text=strCityName;
    _lblMaxTemp.text=[NSString stringWithFormat:@"H: %@",[maxTempArray objectAtIndex:0]];
    _lblLowTemp.text=[NSString stringWithFormat:@"L: %@",[minTempArray objectAtIndex:0]];
    _lblHumidity.text=[NSString stringWithFormat:@"Humidity: %@",[humidityArray objectAtIndex:0]];
    _lblRain.text=[NSString stringWithFormat:@"%@",[minTempArray objectAtIndex:0]];
    _lblCloud.text=[NSString stringWithFormat:@"%@",[minTempArray objectAtIndex:0]];
    _lblCurrentTemp.text=[NSString stringWithFormat:@"%@",[minTempArray objectAtIndex:0]];
    
    
}


#pragma mark- This is 'Get 14 Days Weather Data' button action method which will navigates to Fourteen Days Record ViewController.

- (IBAction)btn14DayrecordsAction:(id)sender
{
    objOfAppDelegate=[[UIApplication sharedApplication]delegate];           //This line enables sharing of data in appdelegate file.
    objOfAppDelegate.strCityNameApDel=[NSMutableString stringWithFormat:@"%@",_txtCity.text];  //Access the city name string in appdelegate file whith the help of object of appdelegate and assign value of UITextfiled City name to it.
    
    if ([_txtCity.text isEqualToString:@""])       //Shows alert if textfiled is empty.
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Sorry !" message: @"Please Enter City Name" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    else
    {
        Fourteen_Days_Records *objOf14DaysRecordsVC=[self.storyboard instantiateViewControllerWithIdentifier:@"14DaysRecords"]; //Navigate with help of ViewController Identifier which is already set to Fourteen Days Records ViewController with the help of storyboard.
        [self.navigationController pushViewController:objOf14DaysRecordsVC animated:YES];
        
        // [self performSegueWithIdentifier:@"14DaysRecords" sender:self];
    }
    
}



#pragma mark- This is 'Get Current Location Weather Detils' button action method which will gives current location weather data..

- (IBAction)GettingCurrentLocationWeatherData:(id)sender
{
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (!networkStatus == NotReachable )
    {
        [_actLoad startAnimating];              //This method starts animation of acivity indicator.
        
        [self startAnimation];                  //This method starts animation of wearher report uiview.
        
        [self getCurrentLocation];          //This method gives user current location i.e. Latitude and longitude.
        
        //        latitude=17.678653;         //Temporary assigned bacause Simulator not giving the latitude and longitude.
        //        longitude=75.894434;
        
        
        [self getCurrentCityName];   //Call this method to get city name with the help of LatLong.
        
        [self GetData:nil];       //This is 'Get Weather Details' button action method which gives weather report of assigned City Name in 'getCurrentCityName' function.
        
    }
    else
    {
        UIAlertView *networkAlert= [[UIAlertView alloc]initWithTitle:@"Network Alert" message:@"Please Connect to Internet To access this Service " delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [networkAlert show];
        
    }
    
    if (latitude==0.0000000 & longitude==0.0000000)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Sorry !" message: @"Fail to get your current location.\nPlease try again" delegate: self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try again",nil];
        [alert show];
    }

}


#pragma mark- This method gives user current location i.e. latitude and longitude.

-(void)getCurrentLocation
{
    
    sourceLocationManager = [[CLLocationManager alloc] init];   //Object of CLLocaiotn manager is defined in .h beacuse alert of the access location services disappears automatically without any user interaction
    sourceLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    sourceLocationManager.delegate=self;

    
    [sourceLocationManager startUpdatingLocation];
    NSLog(@"%@",sourceLocationManager);
    
    //   NSLog(@"%f",sourceLocationManager.location.coordinate.latitude);
    //  NSLog(@"%f",sourceLocationManager.location.coordinate.longitude);
    
    latitude = sourceLocationManager.location.coordinate.latitude;
    longitude = sourceLocationManager.location.coordinate.longitude;
    
  
    //  NSLog(@"%f",latitude);
    //  NSLog(@"%f",longitude);
    
}


#pragma mark - This method contains json parsing which gives city name with the help of latitude and longitude.

-(void)getCurrentCityName
{
    NSString *strUrl=[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast?lat=%f&lon=%f&cnt=1&mode=json",latitude,longitude];       // This url gives all weather data in json format by using lat-lon
    
    
    // NSURL *url=[NSURL URLWithString:@"http://api.openweathermap.org/data/2.5/forecast/daily?q=solapur&mode=json&units=metric&cnt=1"];
    
    NSURL *url=[NSURL URLWithString:strUrl];
    
    NSHTTPURLResponse *response=nil;
    
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
    
    
    NSData *dataNS=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    
    NSMutableDictionary *result=[NSJSONSerialization JSONObjectWithData:dataNS options:NSJSONReadingMutableContainers error:nil];

    NSArray *city=[[NSArray alloc]init];
    city=[result valueForKey:@"city"];
    strCityName=[city valueForKey:@"name"];                 //Here get City name.
    NSLog(@"From LatLong City Name is : %@",strCityName);
    
    _txtCity.text=strCityName;                //Assign city name to UiTextField City name.
    
   
}


#pragma mark- This is UIAlertView Delegate method which gives assigned action by Buttons in AlerView.

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];   //It gives title of pressed button in UIAlertView.
    
    if([title isEqualToString:@"Try again"])
    {
        NSLog(@"Try again...");
        [self GettingCurrentLocationWeatherData:nil];  //Call again for getting user current location if Try Again is pressed by user throgh UIAlertView.
    }
   
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField          //UITextField delegate method used for disappearing keyboard.
{
    
    [textField resignFirstResponder];
    return YES;
    
}




@end
