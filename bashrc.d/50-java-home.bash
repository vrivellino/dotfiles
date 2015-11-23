# setup JAVA_HOME vars, if possible
if [ -x /usr/libexec/java_home ]; then
    java_home_path="$(/usr/libexec/java_home -v 1.7 2> /dev/null)"
    if [ $? -eq 0 ]; then
        export JAVA_7_HOME="$java_home_path"
    fi
    java_home_path="$(/usr/libexec/java_home -v 1.8 2> /dev/null)"
    if [ $? -eq 0 ]; then
        export JAVA_8_HOME="$java_home_path"
    fi
fi

if [ -n "$JAVA_8_HOME" ]; then
    export JAVA_HOME="$JAVA_8_HOME"
fi
