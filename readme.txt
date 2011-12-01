This is a collection of helper classes I have built to make life a little easier. Currently there are only Mac OS X classes but I will likely be adding iOS classes over time as well.
The current liust of classes is as follows:
    TMSCoreCSV - assist in the process of importing and exporting CSV data
    TMSTablePrint - printing tabular data without an NSTableView
    TMSTextView - Convience class that just allows you to set a job title for print jobs involving tabular data
    TMSiCloud - handle sending documents to iCloud as well as opening documents stored there
    TMSiCloudDocument - implements TMSiCloudDelegate protocol as well as handeling saving of itself to iCloud when prompted

Currently TMSCoreCSV will provide you with a string that you can write to the file of your choice that has all the data in CSV format. You just need to provide a 2D array with the rows first in the same way as for TMSTablePrint. Currently the import method is not complete and only completes the first part of the process (it breaks the string into an array of rows but the rows do not get split into individual cells yet).
 
For help with TMSTablePrint and TMSTextView checkout http://www.themikeswan.com/blog/?p=18 for a tutorial that I wrote.

The iCloud classes are also not totally complete yet. Currently if a document is open on more than one machine and one of the copies is changed and saved it will prevent the other copies from being savable until they have been closed and reopened. Once this issue is solved there will also be a TMSiCloudPersistentDocument class for use with Core Data documents (currently using this method for Core Data has the same issue and also causes the other copies to re-load them selves incorrectly).
I will be writing a tutorial for the iCloud classes at some point, but for now here is a little info to get you started:
    In your projects Prefix.pch file you need to define ICLOUD_CONTAINER to be the correct container id for your project.
        #define ICLOUD_CONTAINER @"<teamID>.com.<company>.<appName>"
    Change the superclass of your NSDocument subclass to TMSiCloudDocument (don't forget to import the header).
    Add an instance of TMSiCloud to MainMenu.xib.
    In MainMenu.xib add two menu options; "Open From iCloud...", and "Save to iCloud".
        Connect the "Open From iCloud..." item to the openFromCloud: method of TMSiCloud.
        Connect the "Save to iCloud" item to the sendToiCloud: method under First Responder.
    Provided that you have your project correctly configured to use iCloud you should now be set to use iCloud (except for the current issue with updating files that are open in multiple places).

License Agreement:
 This is exactly the same license agreement that Matt Legend Gemmell uses on his source code. I choose it because I agree with his ideas on this stuff. Feel free to use this class/code as you want. If you use this class in your software I would love acknowledgment of that in your software (such as in the about panel). Of course you can't claim that I endorse or support your software, just that I provided a class for it.
 
 License Agreement for Source Code provided by Mike Swan
 
 This software is supplied to you by Mike Swan in consideration of your agreement to the following terms, and your use, installation, modification or redistribution of this software constitutes acceptance of these terms. If you do not agree with these terms, please do not use, install, modify or redistribute this software.
 
 In consideration of your agreement to abide by the following terms, and subject to these terms, Mike Swan grants you a personal, non-exclusive license, to use, reproduce, modify and redistribute the software, with or without modifications, in source and/or binary forms; provided that if you redistribute the software in its entirety and without modifications, you must retain this notice and the following text and disclaimers in all such redistributions of the software, and that in all cases attribution of Mike Swan as the original author of the source code shall be included in all such resulting software products or distributions. Neither the name, trademarks, service marks or logos of Mike Swan may be used to endorse or promote products derived from the software without specific prior written permission from Mike Swan. Except as expressly stated in this notice, no other rights or licenses, express or implied, are granted by Mike Swan herein, including but not limited to any patent rights that may be infringed by your derivative works or by other works in which the software may be incorporated.
 
 The software is provided by Mike Swan on an "AS IS" basis. MIKE SWAN MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL MIKE SWAN BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF MIKE SWAN HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
