//
//  ABLHealthResult.h
//  ABLAPITester
//
//  Created by Cesare Rocchi on 22/11/2017.
//  Copyright © 2017 Studio Magnolia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABLHealthResult : NSObject

@property(assign) BOOL result;
@property(assign) NSInteger statusCode;
@property(nonatomic, strong) NSString *message;

@end
