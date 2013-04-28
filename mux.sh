#!/opt/bin/bash

# BEGIN - FUNCTION DECLARATIONS

function mux_file {

    if [ $MKV_FILE ]; then

        echo "Muxing $MKV_FILE..."

        VOST_EXTENSION=".VOST.mkv"
        MKV_VOSTFR_FILE=${MKV_FILE:0:${#MKV_FILE}-4}$VOST_EXTENSION
        SRT_FR_FILE=${MKV_FILE:0:${#MKV_FILE}-4}.fr.srt
        SRT_EN_FILE=${MKV_FILE:0:${#MKV_FILE}-4}.en.srt

        MKVMERGE_CMD="-v -o '$MKV_VOSTFR_FILE' '$MKV_FILE'"

        # Check the available subtitle languages
        if [ -f $SRT_FR_FILE ]; then
            MKVMERGE_CMD="$MKVMERGE_CMD --language \"0:fr\" --track-name \"0:Français\" --sub-charset \"0:utf-8\" -s 0 -D -A '$SRT_FR_FILE'"
        fi

        if [ -f $SRT_EN_FILE ]; then
            MKVMERGE_CMD="$MKVMERGE_CMD --language \"0:en\" --track-name \"0:English\" --sub-charset \"0:utf-8\" -s 0 -D -A '$SRT_EN_FILE'"
        fi

        # Check if the output muxed file already exists (based on file name)
        if [ -f $MKV_VOSTFR_FILE ]; then
            echo "$MKV_VOSTFR_FILE already exists ! Aborted."
        # Check if the current file is a muxed file (based on file name)
        elif [ ${#MKV_FILE} -gt ${#VOST_EXTENSION} ] && [ -f ${MKV_FILE:0:${#MKV_FILE}-${#VOST_EXTENSION}}.mkv ]; then
            echo "$MKV_FILE seems to be itself a muxed file ! Aborted."
        # Check if there are available subtitles for the current file
        elif ! [ -f $SRT_FR_FILE ] && ! [ -f $SRT_EN_FILE ]; then
            echo "$MKV_FILE : no subtitles found ! Aborted."
        else
            echo "Executed command : mkvmerge $MKVMERGE_CMD"
            eval "mkvmerge $MKVMERGE_CMD"

            # add permissions
            eval "chmod 666 $MKV_VOSTFR_FILE"

            # add the new mkv file to the multimedia server index
            echo "Adding $MKV_VOSTFR_FILE to the media server index..."
            eval "/usr/syno/bin/synoindex -a '$MKV_VOSTFR_FILE'"
        fi

        # flush vars
        unset SRT_FR_FILE
        unset SRT_EN_FILE       
        unset MKV_VOSTFR_FILE
        unset MKV_FILE

    fi

}

function mux_directory {
    if [ $MKV_PATH ]; then
        for file in "$MKV_PATH"/*.mkv
        do
            MKV_FILE=$file
            mux_file
        done
    fi
}

# END- FUNCTION DECLARATIONS

# --------------------------

# BEGIN - MERGE SCRIPT

OLDIFS="$IFS"
IFS=$'\n'

if [ $# -eq 1 ]; then 
    if [ -d $1 ]; then
        MKV_PATH="$1"
        mux_directory
    elif [ -f $1 ]; then
        MKV_FILE="$1"
        mux_file
    else
        echo "$1 : File or directory not found !"
        IFS="$OLDIFS"
        exit 1
    fi
elif [ $# -eq 0 ]; then
    MKV_PATH="."
    mux_directory
else
    echo "Use : mux [path to the files]"
    IFS="$OLDIFS"
    exit 1
fi

unset MKV_PATH
unset MKV_FILE
IFS="$OLDIFS"

echo "Done."
exit 0

# END - MERGE SCRIPT