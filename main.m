#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc < 3) {
            NSLog(@"---");
            NSLog(@"Batch query for Virus Total written by Predrag Petrovic <me@predrag.dev>");
            NSLog(@"Usage: vt-batch <filepath> <apikey>");
            return 1;
        }

        // Get the file path and api key from the command line arguments
        NSString *filePath = [NSString stringWithUTF8String:argv[1]];
        NSString *apiKey = [NSString stringWithUTF8String:argv[2]];

        // Read the file
        NSError *error;
        NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"Error: %@", error);
            return 1;
        }

        // Split the file content into an array of hashes
        NSArray<NSString *> *hashes = [fileContent componentsSeparatedByString:@"\n"];
        //remove empty strings
        hashes = [hashes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];

        // Create result directory if not exists
        NSString *directoryPath = [NSString stringWithFormat:@"%@/results", [[NSFileManager defaultManager] currentDirectoryPath]];
        if(![[NSFileManager defaultManager] fileExistsAtPath:directoryPath]){
            [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:NO attributes:nil error:nil];
        }

        // Iterate over the array of hashes
        for (__strong NSString *hash in hashes) {
            // Trim the hash to remove any leading or trailing whitespaces
            hash = [hash stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            // Check if the hash is a valid MD5, SHA1 or SHA256 hash
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[a-fA-F0-9]{32}$|^[a-fA-F0-9]{40}$|^[a-fA-F0-9]{64}$" options:NSRegularExpressionCaseInsensitive error:nil];
            if([regex numberOfMatchesInString:hash options:0 range:NSMakeRange(0, [hash length])] == 0){
                NSLog(@"Error: %@ is not a valid hash. Skipping...", hash);
                continue;
            }
            
            // Make the API call
            usleep(1000000);
            NSString *urlString = [NSString stringWithFormat:@"https://www.virustotal.com/vtapi/v2/file/report?apikey=%@&resource=%@", apiKey, hash];
            NSURL *url = [NSURL URLWithString:urlString];
            NSData *data = [NSData dataWithContentsOfURL:url];
            if (data) {
                // Create a file path with the file hash as the file name
                NSString *fileName = [NSString stringWithFormat:@"%@.json", hash];
                NSString *filePath = [directoryPath stringByAppendingPathComponent:fileName];

                // Save the JSON data to the file
                [data writeToFile:filePath atomically:YES];
                NSLog(@"JSON saved to file: %@", filePath);
            } else {
                NSLog(@"Error: Could not fetch data from VirusTotal for hash: %@", hash);
            }
        }
    }
    return 0;
}
