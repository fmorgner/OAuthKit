//
//  OAuthRequestResponse.h
//  OAuthKit
//
//  Created by Felix Morgner on 12.03.12.
//  Copyright (c) 2012 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OAuthRequestResponse : NSObject

- (id)initWithData:(NSData*)theData requestURL:(NSURL*)theRequestURL;
- (OAuthRequestResponse*)responseWithData:(NSData*)theData requestURL:(NSURL*)theRequestURL;

@property (weak, readonly) NSData* responseData;
@property (weak, readonly) NSArray* responseFields;
@property (weak, readonly) NSString* responseType;
@property (weak, readonly) NSURL* requestURL;

@end
