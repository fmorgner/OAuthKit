//
//  OAuthRequest.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 15.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthConsumer.h"
#import "OAuthToken.h"
#import "OAuthParameter.h"
#import "OAuthSignerProtocol.h"

@interface OAuthRequest : NSMutableURLRequest

- (id)initWithURL:(NSURL *)theURL consumer:(OAuthConsumer*)theConsumer token:(OAuthToken*)theToken realm:(NSString*)realm signerClass:(Class)theSignerClass;

+ (OAuthRequest*)requestWithURL:(NSURL *)theURL consumer:(OAuthConsumer*)theConsumer token:(OAuthToken*)theToken realm:(NSString*)theRealm signerClass:(Class)theSignerClass;
+ (OAuthRequest*)request;

- (void)prepare;
- (void)addParameter:(OAuthParameter*)aParameter;

@property(retain) OAuthConsumer* consumer;
@property(retain) OAuthToken*	token;
@property(retain) NSString* realm;
@property(retain) NSString* signature;
@property(retain) NSString* nonce;
@property(retain) NSString* timestamp;
@property(assign) Class signerClass;
@property(assign) NSMutableArray* oauthParameters;
@property(assign,getter = isPrepared) BOOL prepared;

@end
