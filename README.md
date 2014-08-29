JSONDownloader
==============

Lightweight class which downloads and returns a Dictionary rep of JSON object asynchronously


####Usage
import "JSONDownloader.h"

	JSONDownloader *downloader = [[JSONDownloader alloc] init];
	
	[downloader getJSONDataFromURL:[NSURL URLWithString:@"http://wip.niallquinn.me/sample.json"] callback:^(NSDictionary *response){
        //Deal with response callback here
    }];

####Errors
An error will be passed back in Dictionary form

	Key: ERROR!
	Value: Error 
