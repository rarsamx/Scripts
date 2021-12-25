# assume that the script was called like this:
# myscript file1 file2 etc...
# then all the files are in @ARGV

foreach $orig (@ARGV) {
    $orig_fixed = $orig;

    # convert the \ to /
    $orig_fixed =~ s!\\!/!g;

    #split the filename into directory and filename 
    ($dir, $filename) = ($orig_fixed =~ m!^(.*)/([^/]*)$!);

    # create the directory if it doesn't exist
    if (!-e $dir) {
        `mkdir -p $dir`; # -p means create the full path
    }

    # now move the file
    `mv '$orig' $dir/$filename`;

}
