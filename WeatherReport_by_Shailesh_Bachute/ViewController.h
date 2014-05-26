//
//  ViewController.h
//  WeatherReport_by_Shailesh_Bachute
//
//  Created by SHAILESH SHANKAR BACHUTE on 24/05/14.
//  Copyright (c) 2014 SHAILESH SHANKAR BACHUTE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate>
{
    AppDelegate *objOfAppDelegate;
    
    NSMutableArray *listArray,*tempratureArray,*rainArray,*humidityArray,*cloudArray;
    NSMutableArray *dayTempArray,*nightTempArray,*eveningTempArray,*morningTempArray;
    NSMutableArray *minTempArray,*maxTempArray;
    NSMutableString *strCityName,*strCurrentTemp;
  
    float latitude,longitude;           //Float variables to store latlongs.
}
@property (weak, nonatomic) IBOutlet UILabel *lblMaxTemp;
@property (weak, nonatomic) IBOutlet UILabel *lblLowTemp;
@property (weak, nonatomic) IBOutlet UILabel *lblCityName;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentTemp;
@property (weak, nonatomic) IBOutlet UILabel *lblHumidity;
@property (weak, nonatomic) IBOutlet UILabel *lblCloud;
@property (weak, nonatomic) IBOutlet UILabel *lblRain;
@property(nonatomic,retain) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UIButton *btnGetWeatherDetails;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *actLoad;   //Activity Indicator 
@property (weak, nonatomic) IBOutlet UIButton *btn14DaysData;

@end
