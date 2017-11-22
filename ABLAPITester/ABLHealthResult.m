//
//  ABLHealthResult.m
//  ABLAPITester
//
//  Created by Cesare Rocchi on 22/11/2017.
//  Copyright © 2017 Studio Magnolia. All rights reserved.
//

#import "ABLHealthResult.h"

@implementation ABLHealthResult

- (NSString *)description {
  
  return [NSString stringWithFormat:@"result: %i\n statusCode: %li\n message: %@", self.result, (long)self.statusCode, self.message];
  
}

@end
