//
//  LibraryLogger.m
//  LibraryLogger
//
//  Created by Scott Richards on 9/22/16.
//  Copyright © 2016 Scott Richards. All rights reserved.
//

#import "LibraryLogger.h"
#import <mach-o/dyld.h>
#import <dlfcn.h>


@implementation LibraryLogger



static void _print_image(const struct mach_header *mh, bool added)
{
    Dl_info image_info;
    int result = dladdr(mh, &image_info);
    
    if (result == 0) {
        printf("Could not print info for mach_header: %p\n\n", mh);
        return;
    }
    
    const char *image_name = image_info.dli_fname;
    
    const intptr_t image_base_address = (intptr_t)image_info.dli_fbase;
//    const uint64_t image_text_size = _image_text_segment_size(mh);
    
    char image_uuid[37];
//    const uuid_t *image_uuid_bytes = _image_retrieve_uuid(mh);
//    uuid_unparse(*image_uuid_bytes, image_uuid);
    
    const char *log = added ? "Added" : "Removed";
//    printf("%s: 0x%02lx (0x%02llx) %s <%s>\n\n", log, image_base_address, image_text_size, image_name, image_uuid);
        printf("%s: 0x%02lx %s\n\n", log, image_base_address, image_name);
}

static void image_added(const struct mach_header *mh, intptr_t slide)
{
    _print_image(mh, true);
}

static void image_removed(const struct mach_header *mh, intptr_t slide)
{
    _print_image(mh, false);
}

+ (void)load
{
    _dyld_register_func_for_add_image(&image_added);
    _dyld_register_func_for_remove_image(&image_removed);
}

@end
