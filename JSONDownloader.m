/*
The MIT License (MIT)

Copyright (c) 2014 Niall Quinn.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

#import "JSONDownloader.h"

@implementation JSONDownloader {
    NSMutableData *_responseData;
    void(^callback)(NSDictionary *response);
}

- (id) init {
    if (self = [super init]) {
        return self;
    }
    return nil;
}

- (void) getJSONDataFromURL:(NSURL*)url callback:(void (^)(NSDictionary *response))completion {
    
    callback = completion;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];

}

- (void) parseJSON {
    
    NSError *localError;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:&localError];
    
    if (localError != nil) {
        parsedObject = [NSDictionary dictionaryWithObject:localError forKey:@"ERROR!"];
    }
    
    callback(parsedObject);
    _responseData = nil;
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // Response was recieved, create the data variable
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    [self parseJSON];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSDictionary *response = [NSDictionary dictionaryWithObject:error forKey:@"ERROR"];
    callback(response);
}


@end
