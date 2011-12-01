/*
  TMSiCloud.m

  Created by Michael Swan on 11/6/11.
  Copyright (c) 2011 Michael S. Swan. All rights reserved.

 This is exactly the same license agreement that Matt Legend Gemmell uses on his source code. I choose it because I agree with his ideas on this stuff. Feel free to use this class/code as you want. If you use this class in your software I would love acknowledgment of that in your software (such as in the about panel). Of course you can't claim that I endorse or support your software, just that I provided a class for it.
 
 License Agreement for Source Code provided by Mike Swan
 
 This software is supplied to you by Mike Swan in consideration of your agreement to the following terms, and your use, installation, modification or redistribution of this software constitutes acceptance of these terms. If you do not agree with these terms, please do not use, install, modify or redistribute this software.
 
 In consideration of your agreement to abide by the following terms, and subject to these terms, Mike Swan grants you a personal, non-exclusive license, to use, reproduce, modify and redistribute the software, with or without modifications, in source and/or binary forms; provided that if you redistribute the software in its entirety and without modifications, you must retain this notice and the following text and disclaimers in all such redistributions of the software, and that in all cases attribution of Mike Swan as the original author of the source code shall be included in all such resulting software products or distributions. Neither the name, trademarks, service marks or logos of Mike Swan may be used to endorse or promote products derived from the software without specific prior written permission from Mike Swan. Except as expressly stated in this notice, no other rights or licenses, express or implied, are granted by Mike Swan herein, including but not limited to any patent rights that may be infringed by your derivative works or by other works in which the software may be incorporated.
 
 The software is provided by Mike Swan on an "AS IS" basis. MIKE SWAN MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL MIKE SWAN BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF MIKE SWAN HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */

#import "TMSiCloud.h"
@interface TMSiCloud ()
- (NSURL *)iCloudDocumentURL:(NSString *)container;
- (BOOL)upload:(NSURL *)local toiCloud:(NSURL *)cloud;
@end

@implementation TMSiCloud
@synthesize delegate;
@synthesize documentURL;

- (id)init {
    self = [super init];
    if (self) {
        self.documentURL = nil;
        NSOperationQueue *aQueue = [[NSOperationQueue alloc] init];
        [aQueue addOperationWithBlock:^{
            [self setDocumentURL:[self iCloudDocumentURL:ICLOUD_CONTAINER]];
        }];
    }
    return self;
}

- (void)sendFile:(NSURL *)local toContainer:(NSString *)container {
    if (self.documentURL == nil) {
        [self.delegate file:local sentToiCloud:NO];
        return;
    }
    NSURL *cloud = [self.documentURL URLByAppendingPathComponent:[local lastPathComponent] isDirectory:NO];
    BOOL success = [self upload:local toiCloud:cloud];
    [self.delegate file:local sentToiCloud:success];
}

- (NSURL *)iCloudDocumentURL:(NSString *)container {
    NSFileManager *fileMan = [NSFileManager defaultManager];
    // Get the iCloud container
    NSURL *url = [fileMan URLForUbiquityContainerIdentifier:container];
    // Make sure it worked
    if (url == nil) {
        NSLog(@"Error connecting to iCloud, no container found. Plaese make sure you are logged in.");
        return url;
    }
    // Add /Documents to the URL
    url = [url URLByAppendingPathComponent:@"Documents" isDirectory:YES];
    // Check to see if the directory exists yet
    if (![fileMan fileExistsAtPath:[url path]]) {
        NSError *anError = nil;
        // Attempt to create the directory
        if (![fileMan createDirectoryAtURL:url withIntermediateDirectories:NO attributes:nil error:&anError]) {
            // Clearly we have failed
            NSLog(@"Error creating Documents directory in iCloud: %@", anError.localizedDescription);
            return nil;
        }
    }
    return url;
}

- (BOOL)upload:(NSURL *)local toiCloud:(NSURL *)cloud {
    NSError *anError = nil;
    BOOL result = [[NSFileManager defaultManager] setUbiquitous:YES itemAtURL:local destinationURL:cloud error:&anError];
    if (!result) {
        NSLog(@"Error uploading %@ to iCloud: %@", [local lastPathComponent], anError.localizedDescription);
    }
    return result;
}

#pragma mark -
#pragma mark file Open stuff
- (IBAction)openFromCloud:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setDirectoryURL:self.documentURL];
    [panel setAllowsMultipleSelection:NO];
    [panel setDelegate:self];
    NSInteger result = [panel runModal];
    if (result == NSFileHandlingPanelOKButton) {
        [[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:[[panel URLs] objectAtIndex:0] display:YES completionHandler:^(NSDocument *document, BOOL documentWasAlreadyOpen, NSError *error) { }];
    }
}

#pragma mark NSOpenPanel Delegate methods
- (BOOL) panel:(id)sender shouldEnableURL:(NSURL *)url {
    NSString *path = [url path];
    NSString *cloudDir = [self.documentURL path];
    return [path hasPrefix:cloudDir];
}

- (void) panel:(id)sender didChangeToDirectoryURL:(NSURL *)url {
    NSString *path = [url path];
    NSString *cloudDir = [self.documentURL path];
    if (![path hasPrefix:cloudDir]) [sender setDirectoryURL:self.documentURL];
}

@end
