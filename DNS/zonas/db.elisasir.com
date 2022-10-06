$TTL    3600
@       IN      SOA     ns.elisasir.com. some.email.address. (
                        2000000005  ;   Serial
                        3600        ;   Refresh [1h]
                        600         ;   Retry   [10m]
                        86400       ;   Expire  [1d]
                        86400       ;   minimum [1m]
                        )

@       IN      NS      ns.elisasir.com.
ns      IN      A       10.1.0.224
test    IN      A       10.1.0.2
alias   IN      CNAME   test
