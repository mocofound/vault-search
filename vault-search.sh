#!/usr/bin/env bash

#Define Variables
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN=root

#Setup/Testing
	write1=$(vault kv put secret/hello foo=world foofoo=barbar 2>&1)
	write2=$(vault kv put secret/goodbye bar=hello 2>&1)


# Recursive function that will
# - List all the secrets in the given $path
# - Call itself for all path values in the given $path
function traverse {
    local -r path="$1"
    local -r searchterm="$2"
    #echo "$searchterm"
    result=$(vault kv list -format=json $path 2>&1)
   
    status=$?
    if [ ! $status -eq 0 ];
    then
        if [[ $result =~ "permission denied" ]]; then
            return
        fi
        >&2 echo "   " + "$result"
    fi

    for secret in $(echo "$result" | jq -r '.[]'); do
        #echo "$result" | jq
        if [[ "$secret" == */ ]]; then
            traverse "$path$secret"
        else
            echo " "
            echo "Path: $path$secret"
            getresult=$(vault kv get -format=json $path$secret 2>&1)
            #TODO:fix getresult
            #echo "$getresult" | jq -r '.data.data | keys ' 
            #echo "$getresult" | jq -r '.data.data | keys[] ' 
            echo "my_searchterm2: $searchterm"
            if [[ ""$getresult" | jq -r '.data.data | keys '" =~ "${2%}" ]]; then
                echo "foofooofoo"
            fi
        fi
    done
}

# Iterate on all kv engines or start from the path provided by the user
if [[ "$1" ]]; then
    # Make sure the path always end with '/'
    vaults=("${1%"/"}/")
else
    vaults=$(vault secrets list -format=json | jq -r 'to_entries[] | select(.value.type =="kv") | .key')
fi

echo "$vaults"
for vault in $vaults; do
    echo "searchterm: ${2%}"
    traverse $vault
done
