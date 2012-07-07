//
//  OAuthRequestFetcher.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 21.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OAuthRequestFetcher : NSObject

- (void)fetchRequest:(NSURLRequest*)aRequest completionHandler:(void (^)(id fetchResult))block;

@property(nonatomic,strong) NSURLRequest* request;
@property(nonatomic,strong) NSURLConnection* connection;
@property(nonatomic,strong) NSMutableData* receivedData;
@property(nonatomic,copy) void (^completionHandler)(id);


@end
