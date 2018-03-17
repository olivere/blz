# BLZ&mdash;Bankleitzahlen in Ruby

## Description

BLZ or Bankleitzahlen is a bank identifier code system used by German
and Austrian banks (see [Wikipedia](https://en.wikipedia.org/wiki/Bankleitzahl)).

This gem provides for searching and returning the information
represented by the BLZ, such as the name of the bank etc.

## Installation

    $ gem install blz

## Command line tools

I provided a command line tool to search for BLZ:

```sh
$ blz exact 70150000
70150000, Stadtsparkasse München, 80791 München, SSKMDEMMXXX
```

Or search for BIC matches:

```sh
$ blz bic SSKMDE
70150000, Stadtsparkasse München, 80791 München, SSKMDEMMXXX
```

Or use substring matches:

```sh
$ blz match 4945
49450120, Sparkasse Herford, 32045 Herford, WLAHDE44XXX
49450120, Sparkasse Herford, 32285 Rödinghausen, Westf
49450120, Sparkasse Herford, 32132 Spenge
49450120, Sparkasse Herford, 32269 Kirchlengern
49450120, Sparkasse Herford, 32122 Enger, Westf
49450120, Sparkasse Herford, 32591 Vlotho
49450120, Sparkasse Herford, 32120 Hiddenhausen
49450120, Sparkasse Herford, 32221 Bünde
49450120, Sparkasse Herford, 32556 Löhne
49451210, Sparkasse Bad Salzuflen -alt-, 32102 Bad Salzuflen, WELADED1BSU
```

Or find by city (rather uncommon, but useful):

```sh
$ blz city Münstereifel
37069627, Raiffeisenbank Rheinbach Voreifel, 53902 Bad Münstereifel
37070024, Deutsche Bank Privat und Geschäftskunden, 53902 Bad Münstereifel, DEUTDEDB379
37070060, Deutsche Bank, 53902 Bad Münstereifel, DEUTDEDK379
38250110, Kreissparkasse Euskirchen, 53896 Bad Münstereifel
38260082, Volksbank Euskirchen, 53895 Bad Münstereifel
```

## Downloads

You can download the current list of BLZ (free of charge)
[from the German Bundesbank](http://www.bundesbank.de/Redaktion/DE/Standardartikel/Kerngeschaeftsfelder/Unbarer_Zahlungsverkehr/bankleitzahlen_download.html),
however, you need to complete their [registration process](https://extranet.bundesbank.de/bsvpub/).

The Bundesbank releases a new list every three months. The last part of the
version number of this gem mirrors the last date the provided data is valid.

Now go and build your own BLZ gem ;-)

### Note on converting

If you have an Extranet account, you may use the `scripts/fetch.rb` helper,
which will perform login, download, conversion (and logout). You need to
provide it with your credentials, like so:

```sh
$ EXTRANET_USERNAME="..." EXTRANET_PASSWORD="..." scripts/fetch.rb
```

It will create a new `data/*.tsv.gz` file or do nothing if the download
provided already exists.

Note, that you'll need to clone this repository and execute `bundle` in
the repository directory to fetch development dependencies.

## Contributors

* [dmke](https://github.com/dmke)
* [max-power](https://github.com/max-power)

## License

Released under the MIT License. See the LICENSE file for further
details.

