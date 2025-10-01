#/bin/bash

check_release()
{
    current=$(sed -n '/^\[VERSION\]/{n;p;}' "$(dirname $1)/Config.txt")
    current=${current//,/.}
    current=${current%%+*}

    release_url=$(head -n 1 $1)
    format=$(echo $release_url | cut -d " " -f 2)

    release_url=$(echo $release_url | cut -d " " -f 1)
    data=$(curl -s $release_url)
    if [ "$format" == "base64" ]; then
        data=$(echo $data | base64 --decode)
    fi

    regex=$(tail -n 1 $1)
    latest=$(echo "$data" | grep -Po "$regex" | sort -V | tail -n 1)
    if [ -n "$latest" ]; then
        dot_count=$(echo $latest | grep -o "\." | wc -l)
        if [ "$dot_count" = "1" ]; then
            latest="$latest.0"
        fi
    else
        latest="unable to load version"
    fi

    if [ "$current" = "$latest" ]; then
        return 0
    fi

    project=$(basename $(dirname $(dirname $1)))
    echo "$project ${current} => ${latest} (${release_url})"
    return 1
}

exit_code=0

for release_info in $(find . -name "release-info"); do
    check_release $release_info
    if [ $? != 0 ]; then
        exit_code=1
    fi
done

exit $exit_code
