
function __vpn-is-connected() {
    /opt/cisco/anyconnect/bin/vpn status | grep -q Connected
    local _status=$?
    if [ $_status -eq 0 ]; then
        return 0
    fi
    return 1
}

function vpn() {
    case "$1" in 
        on|connect)
            if (__vpn-is-connected); then
                echo "VPN is already connected"
                return 1
            else
                echo -n "Token:"
                read -s password
                echo 

                echo "${VPN_USERNAME}\n${password}\ny" | /opt/cisco/anyconnect/bin/vpn -s connect $VPN_PROFILE
                return 0
            fi
            ;;
        off|disconnect)
            if (__vpn-is-connected); then
                /opt/cisco/anyconnect/bin/vpn -s disconnect
                return 0
            else
                echo "VPN is not connected"            
                return 1
            fi

            ;;
        status|st)
            if (__vpn-is-connected); then
                echo "VPN is CONNECTED"
                return 0
            else
                echo "VPN is DISCONNECTED"
                return 0
            fi

            return 1
            ;;
        *)
            echo "Usage: $0 {on|off|status}"
            return 1    
    esac
}
