> File: cap10.tech\namecheap\acme-adventure.md
 
-  

```shell
curl https://get.acme.sh | sh -s email=bill@cap10.tech
```

- issue 

```shell
acme.sh --register-account -m bill@cap10.tech --server zerossl --eab-kid "your_kid" --eab-hmac-key "your_hmac_key"

```

```shell
acme.sh --issue -d *.cap10.tech -w /home/zxbohwkn/public_html  --dns --yes-I-know-dns-manual-mode-enough-go-ahead-please
```
```shell
acme.sh --issue -d example.com -d '*.example.com'
```