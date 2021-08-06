# vault-search
This is experimental and not recommended in production.

# usage
./vault-list.sh /my-kv-secret-engine my-search-term 

# example
$ ./vault-list.sh /secret bar


    /secret/

    searchterm: bar

    Path: /secret/goodbye
    [
      "bar"
    ]

    Path: /secret/hello
    [
      "foo",
      "foofoo"
    ]
