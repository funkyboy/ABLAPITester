//
//  ViewController.m
//  ABLAPITester
//
//  Created by Cesare Rocchi on 22/11/2017.
//  Copyright © 2017 Studio Magnolia. All rights reserved.
//

#import "ViewController.h"
#import "ABLHealthResult.h"

#define ENDPOINT @"https://rest.ably.io"

@protocol ABLHealthCheckDelegate <NSObject>
- (void)apiChecked:(ABLHealthResult *)result;
@end

@interface ViewController () <ABLHealthCheckDelegate>

@property(nonatomic, weak) id <ABLHealthCheckDelegate> delegate;
- (void)checkAPI;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.delegate = self;
}



- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)checkAPI {
  
  NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
  NSDictionary *headers = @{};
  sessionConfiguration.HTTPAdditionalHeaders = headers;
  NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                        delegate:nil
                                                   delegateQueue:[NSOperationQueue mainQueue]];
  NSURL *url = [NSURL URLWithString:ENDPOINT];
  NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
  
  ABLHealthResult *healthResult = [ABLHealthResult new];
  [[session dataTaskWithRequest:request
              completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error == nil) {
                  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                  if ([httpResponse statusCode] > 199 && [httpResponse statusCode] < 300) {
                    healthResult.result = YES;
                    healthResult.statusCode = [httpResponse statusCode];
                  } else {
                    healthResult.result = NO;
                    healthResult.statusCode = [httpResponse statusCode];
                    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                               options:kNilOptions
                                                                                 error:nil];
                    NSDictionary *errorDictionary = jsonObject[@"error"];
                    if (errorDictionary != nil) {
                      healthResult.message = errorDictionary[@"message"];
                    }
                  }
                } else {
                  healthResult.result = NO;
                  healthResult.message = [error localizedDescription];
                }
                [self.delegate apiChecked:healthResult];
              }] resume];
  
}

- (IBAction)startTestingAPI:(id)sender {
  
  [self checkAPI];
  
}

- (void)apiChecked:(ABLHealthResult *)result {
  
  NSLog(@"Health check %@", result);
  
}

@end
