//
//  main.m
//  macmlh
//
//  Created by vimtaku on 2014/05/05.
//  Copyright (c) 2014年 vimtaku. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <InputMethodKit/InputMethodKit.h>

const NSString* kConnectionName = @"MacMlh_Connection";

IMKServer*       server;


int main(int argc, const char * argv[])
{
    
    NSString*       identifier;
    NSLog(@"holly fucking shit");
	
	//find the bundle identifier and then initialize the input method server
    identifier = [[NSBundle mainBundle] bundleIdentifier];
    server = [[IMKServer alloc] initWithName:(NSString*)kConnectionName bundleIdentifier:[[NSBundle mainBundle] bundleIdentifier]];
	
    //load the bundle explicitly because in this case the input method is a background only application
	[NSBundle loadNibNamed:@"MainMenu" owner:[NSApplication sharedApplication]];
	
	//finally run everything
	[[NSApplication sharedApplication] run];
	
    return 0;

}
