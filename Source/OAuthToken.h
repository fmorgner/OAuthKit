//
//  OAuthToken.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 14.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OAuthToken : NSObject

- (id)initWithKey:(NSString*)theKey secret:(NSString*)theSecret authorized:(BOOL)isAuthorized;

+ (OAuthToken*)token;
+ (OAuthToken*)tokenWithKey:(NSString*)theKey secret:(NSString*)theSecret authorized:(BOOL)isAuthorized;

@property(nonatomic, strong) NSString* key;
@property(nonatomic, strong) NSString* secret;
@property(nonatomic, getter = isAuthorized) BOOL authorized;

@end
