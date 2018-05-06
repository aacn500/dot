
__gov_usage() {
    echo "Usage: gov <command> [options]"
    echo "Commands:"
    echo "  install - installs named go version (Use \"latest\" to get latest)"
    echo "  switch - switchs enabled go version"
    echo "  versions - lists all installed go versions"
}

__gov_install_usage() {
    echo "Usage: gov install <version>"
    echo "Version strings look like: go1.9.1"
    echo "Use \"latest\" to get latest go version"
}

__gov_curl() {
    curl -s "$@"
}

__gov_latest_go_version() {
    __gov_curl "https://golang.org/VERSION?m=text"
}

__gov_installed_go_versions() {
    ls $GOPATH | grep "^go[[:digit:]\.]\+$" | sort -g
}

__gov_install_go_version() {
    if [ -d $GOPATH/$1 ]; then
        echo "Go version $1 is already installed"
        echo "If you want to switch to version $1, you should use \`gov switch' instead"
    else
        mkdir $GOPATH/$1
        __gov_curl "https://dl.google.com/go/${1}.linux-amd64.tar.gz" | tar xzf - -C $GOPATH/${1} --strip-components=1
    fi
}

__gov_install() {
    if [ -z ${1+x} ]; then
        __gov_install_usage
    elif [ $1 = "latest" ]; then
        __gov_install_go_version $(__gov_latest_go_version)
    else
        __gov_install_go_version $1
    fi
}

__gov_versions() {
    __gov_installed_go_versions
}

__gov_switch() {
    old_ver=$(cat $gov_config)
    if [ -z ${1+x} ]; then
        __gov_install_usage
        return
    elif [ $1 = "latest" ]; then
        go_ver=__gov_installed_go_versions | tail -n1
    else
        go_ver=$1
    fi

    echo $go_ver > $gov_config
    old_root=$GOPATH/$old_ver
    export GOROOT=$GOPATH/$go_ver
    export path=(${(@)path:#$old_root/bin} $GOROOT/bin)
}


gov() {
    if [ -z ${1+x} ]; then
        __gov_usage
    elif [ $1 = "install" ]; then
        __gov_install "${@:2}"
    elif [ $1 = "versions" ]; then
        __gov_versions "${@:2}"
    else
        __gov_usage
    fi
}

if [ -z ${GOPATH+x} ]; then
    export GOPATH=$HOME/go
fi

export PATH=$PATH:$GOPATH/bin
gov_config=$GOPATH/.gov

if [ -n __gov_installed_go_versions ]; then
    if [ ! -f $gov_config ]; then
        echo $(__gov_installed_go_versions | tail -n1) > $gov_config
    fi
    __gov_switch $(cat $gov_config)
fi
