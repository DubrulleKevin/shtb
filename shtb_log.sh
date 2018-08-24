# Usage   : shtb_log <DEBUG|INFO|WARNING|ERROR|FATAL> message.
# Env     : Look for the globally set wanted log level on SHTB_LOG_LEVEL.
# Returns : 0 => OK
#         : 1 => Bad arguments
shtb_log () (
    BAD_ARGS_CODE=1
    USAGE_STRING="Usage: shtb_log <DEBUG|INFO|WARNING|ERROR|FATAL> message"
    DEBUG=0
    INFO=1
    WARNING=2
    ERROR=3
    FATAL=4
    SHTB_LOG_DEFAULT_LEVEL="INFO"

    # Check arguments

    if [ $# -lt 2 ]; then
        echo $USAGE_STRING >&2
        return $BAD_ARGS_CODE
    fi
    
    LOG_LEVEL=$1

    case $LOG_LEVEL in
        "DEBUG")
            LOG_LEVEL_VALUE=$DEBUG
            ;;
        "INFO")
            LOG_LEVEL_VALUE=$INFO
            ;;
        "WARNING")
            LOG_LEVEL_VALUE=$WARNING
            ;;
        "ERROR")
            LOG_LEVEL_VALUE=$ERROR
            ;;
        "FATAL")
            LOG_LEVEL_VALUE=$FATAL
            ;;
        *)
            echo $USAGE_STRING >&2
            return $BAD_ARGS_CODE
            ;;
    esac

    shift

    # Here we are sure that arguments are OK.

    # Now, check if SHTB_LOG_LEVEL exists, and compare the LOG_LEVEL given in parameter.
    # If SHTB_LOG_LEVEL is not set, print a warning, and set SHTB_LOG_LEVEL
    # to a default value given by SHTB_LOG_DEFAULT_LEVEL.

    if [ -z ${SHTB_LOG_LEVEL:-} ]; then
        echo "`date +'%d/%m/%y - %H:%M:%S'` - `basename ${0}` - WARNING - SHTB_LOG_LEVEL is not set, take INFO as default."
        SHTB_LOG_LEVEL=$SHTB_LOG_DEFAULT_LEVEL
    fi

    case $SHTB_LOG_LEVEL in
        "DEBUG")
            SHTB_LOG_LEVEL_VALUE=$DEBUG
            ;;
        "INFO")
            SHTB_LOG_LEVEL_VALUE=$INFO
            ;;
        "WARNING")
            SHTB_LOG_LEVEL_VALUE=$WARNING
            ;;
        "ERROR")
            SHTB_LOG_LEVEL_VALUE=$ERROR
            ;;
        "FATAL")
            SHTB_LOG_LEVEL_VALUE=$FATAL
            ;;
        *)
            echo "`date +'%d/%m/%y - %H:%M:%S'` - `basename ${0}` - FATAL - SHTB_LOG_LEVEL has a bad value: ${SHTB_LOG_LEVEL}. Should be <DEBUG|INFO|WARNING|ERROR|FATAL>."
            return $BAD_ARGS_CODE
            ;;
    esac

    # Now, print the message if LOG_LEVEL > SHTB_LOG_LEVEL_VALUE.

    if [ $LOG_LEVEL_VALUE -ge $SHTB_LOG_LEVEL_VALUE ]; then
        echo "`date +'%d/%m/%y - %H:%M:%S'` - `basename ${0}` - $LOG_LEVEL - ${*}"
    fi

    return 0
)

shtb_log $*
