= domain-generator

== instalation

```bash
git clone repo_url domain-generator
cd domain generator
bundle install
```

== usage

All possible options:

```bash
./generate.rb tlds=com,com.pl,pl,dev,it [random=1] [domain1, [domain2, ... [domainN]]] [debug=1]
```

where:

- `tlds` is a list of all top level domains separated by comma
- `random` is a number of randomly picked domains
- `domain1..N` are list off domains, each is passed as separated arguments
- `debug=1` with dumps application config
