

function Flush-DNS {
    sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder
}

