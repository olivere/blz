# BLZ&mdash;Bankleitzahlen in Ruby

## Description

BLZ or Bankleitzahlen is a bank identifier code system used by German
and Austrian banks (see [Wikipedia](http://en.wikipedia.org/wiki/Bankleitzahl)). 
 
This gem provides for searching and returning the information
represented by the BLZ, such as the name of the bank etc.

## Installation

    $ gem install blz

## Command line tools

I provided a command line tool to search for BLZ:

    blz exact 70150000
    
    70150000, Stadtsparkasse München, 80791 München, SSKMDEMMXXX

Or use substring matches:

    blz match 4945

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

Or find by city (rather uncommon, but useful):

    blz city Münstereifel

    37069627, Raiffeisenbank Rheinbach Voreifel, 53902 Bad Münstereifel
    37070024, Deutsche Bank Privat und Geschäftskunden, 53902 Bad Münstereifel, DEUTDEDB379
    37070060, Deutsche Bank, 53902 Bad Münstereifel, DEUTDEDK379
    38250110, Kreissparkasse Euskirchen, 53896 Bad Münstereifel
    38260082, Volksbank Euskirchen, 53895 Bad Münstereifel

## Downloads

You can download the current list of BLZ (free of charge)
from the German Bundesbank
[here](http://www.bundesbank.de/Redaktion/DE/Standardartikel/Kerngeschaeftsfelder/Unbarer_Zahlungsverkehr/bankleitzahlen_download.html).
Now go and build your own BLZ gem ;-)

## Contributors

* [dmke](https://github.com/dmke)
* [max-power](https://github.com/max-power)

## License

Released under the MIT License. See the LICENSE file for further
details.

