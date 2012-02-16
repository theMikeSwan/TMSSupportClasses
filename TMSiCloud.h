/*
  TMSiCloud.h

  Created by Michael Swan on 11/6/11.
  Copyright (c) 2011 Michael S. Swan. All rights reserved.
  
  Class escription: Designed to handle sending documents to iCloud as well as opening documents stored there.

 This is exactly the same license agreement that Matt Legend Gemmell uses on his source code. I choose it because I agree with his ideas on this stuff. Feel free to use this class/code as you want. If you use this class in your software I would love acknowledgment of that in your software (such as in the about panel). Of course you can't claim that I endorse or support your software, just that I provided a class for it.
 
 License Agreement for Source Code provided by Mike Swan
 
 This software is supplied to you by Mike Swan in consideration of your agreement to the following terms, and your use, installation, modification or redistribution of this software constitutes acceptance of these terms. If you do not agree with these terms, please do not use, install, modify or redistribute this software.
 
 In consideration of your agreement to abide by the following terms, and subject to these terms, Mike Swan grants you a personal, non-exclusive license, to use, reproduce, modify and redistribute the software, with or without modifications, in source and/or binary forms; provided that if you redistribute the software in its entirety and without modifications, you must retain this notice and the following text and disclaimers in all such redistributions of the software, and that in all cases attribution of Mike Swan as the original author of the source code shall be included in all such resulting software products or distributions. Neither the name, trademarks, service marks or logos of Mike Swan may be used to endorse or promote products derived from the software without specific prior written permission from Mike Swan. Except as expressly stated in this notice, no other rights or licenses, express or implied, are granted by Mike Swan herein, including but not limited to any patent rights that may be infringed by your derivative works or by other works in which the software may be incorporated.
 
 The software is provided by Mike Swan on an "AS IS" basis. MIKE SWAN MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL MIKE SWAN BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF MIKE SWAN HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */

#import <Foundation/Foundation.h>
@protocol TMSiCloudDelegate
-(void)file:(NSURL *)file sentToiCloud:(BOOL)success;
@end

@interface TMSiCloud : NSObject <NSOpenSavePanelDelegate>
@property (weak) NSObject <TMSiCloudDelegate> *delegate;
@property (strong, atomic) NSURL *documentURL;

- (IBAction)openFromCloud:(id)sender;
- (void)sendFile:(NSURL *)local toContainer:(NSString *)container;
@end



