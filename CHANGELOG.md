# 0.1.4.20170306, released 2017-02-06

* BLZ data file for cycle 2017-03-06 to 2017-06-04 added
* data for 2016-09-04 until 2017-03-06 is unavailable, sorry

# 0.1.4.20160904, released 2016-05-15

* BLZ data file for cycle 2016-03-06 to 2016-09-04 added

# 0.1.4.20160306, released 2015-12-04

* BLZ data file for cycle 2015-12-07 to 2016-03-06 added
* removed data files for 2012-2014
* refactored data file finder logic

# 0.1.4.20151206, released 2015-08-19

* BLZ data file for cycle 2015-09-07 to 2015-12-06 added

# 0.1.4.20150607, released 2015-03-09

* BLZ data file for cycle 2015-06-09 to 2015-09-07 added

# 0.1.4.20141207, released 2014-09-08

* pinned data to last update cycle (there were no changes)
  This only gets rid of the "[BLZ] The data provided may not be accurate."
  warning.

# 0.1.4.20140907.2, released 2014-07-25

* finders return an empty array when given `nil` or a blank string

# 0.1.4.20140907.1, released 2014-07-11

* apply update BIC of Sberbank (SEZBDEF1XXX → SEZDDEF1XXX)
  after Bundesbank ExtraNet notifcation from 2014-07-10

# 0.1.4.20140907, released 2014-06-26

* BLZ data file for cycle 2014-06-09 to 2014-09-07 added
* generalized finder for `BLZ::DATA_FILE`

# 0.1.4.20140608, released 2014-02-13

* BLZ data file for cycle 2014-03-03 to 2014-06-08 added
* compressed data files for smaller gem size
* added `BLZ::Bank.find_by_bic` method
* removed XLSX source files

# 0.1.3, released 2013-02-12

* BLZ data file for cycle 2013-12-09 to 2014-03-02 added

# 0.1.2, released 2012-11-18

* BLZ data file not correctly resolved when
  using blz script

# 0.1.1, released 2012-11-18

* Fixes a bug with `nil` values (kudos to @max-power)
* Refactoring code, and it's just better to
  read now (again, thanks to @max-power)

# 0.1.0, released 2012-09-27

* Initial version released on GitHub
