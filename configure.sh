#!/bin/bash
#
#              ImageMagick Xcode Configuration
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# https://github.com/emcconville/imagemagick-xcode-configuration
#

ok() {
    printf "\x1B[32mOK\x1B[0m   %-20s\n" "$1"
}

fail() {
    printf "\x1B[31mFAIL\x1B[0m %-20s\n" "$1"
}

create_xcode_magick_config() {
    if [ -z "$1" -o -z "$2" ]
    then
        return 1
    fi
    echo '// ' $2 $(date)                   >  $2
    echo 'OTHER_CFLAGS = ' $($1 --cxxflags) >> $2
    echo 'OTHER_LDFLAGS = ' $($1 --ldflags) >> $2
    return 0
}


# Parse self and dump out the header comments
grep -E '^\#' $0 | tail -n+2 | cut -c 3-

# Generated Xcode config file for each ImageMagick family
# TODO IM 7 will deprecate config utlities
for SAPI in "MagickCore" "MagickWand" "Magick++"
do
    OUTFILE="${SAPI}.xcconfig"
    printf %-20s $SAPI \
        && create_xcode_magick_config $(which ${SAPI}-config) $OUTFILE \
        && ok "created ${OUTFILE}" \
        || fail "missing ${SAPI}-config"
done

exit 0
