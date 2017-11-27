
#!/usr/bin/env bash

RED=$( tput setaf 1 )
GREEN=$( tput setaf 2 )
RESET=$( tput sgr0 )

echo "Checking whether Puma is running"
ps aux | grep puma | grep -v grep > /dev/null
if [ ! $? = "0" ]
then
    echo "$RED Puma was not started $RESET"
    exit 1
else
    echo "$GREEN Puma has been successfully started $RESET"
    exit 0
fi

echo "Puma process output"
cat puma_proc.out
