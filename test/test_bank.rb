# encoding: utf-8

require 'blz'
require 'test/unit'

class TestBank < Test::Unit::TestCase

  def test_data_file_finder
    {
      Date.new(2000,1,1)  => "2015_03_09.tsv.gz",
      Date.new(2015,1,1)  => "2015_03_09.tsv.gz",
      Date.new(2015,3,9)  => "2015_03_09.tsv.gz",

      Date.new(2015,3,10) => "2015_12_06.tsv.gz",
      Date.new(2015,6,25) => "2015_12_06.tsv.gz",
      Date.new(2015,12,6) => "2015_12_06.tsv.gz",

      Date.new(2015,12,7) => "2016_03_06.tsv.gz",
      Date.new(2016,3,6)  => "2016_03_06.tsv.gz",
      Date.new(2016,3,7)  => "2016_09_04.tsv.gz",
      Date.new(2016,9,5)  => "2016_09_04.tsv.gz", # ! until next release cycle
    }.each do |date, filename|
      file = BLZ.find_data_file(date)
      assert_equal filename, File.basename(file)
    end
  end

  def test_current_data_file
    assert_match /\A\d{4}_\d\d_\d\d\.tsv\.gz\z/, File.basename(BLZ::DATA_FILE)
  end

  def test_all_banks
    assert !BLZ::Bank.all.nil?
    assert sskm = BLZ::Bank.all.find { |b| b.blz == "70150000" }
    assert_equal "Stadtsparkasse München", sskm.name
  end

  def test_search_by_exact_match_munich
    assert results = BLZ::Bank.find_by_blz("70150000", :exact => true)
    assert_equal 1,                         results.size
    assert_equal "70150000",                results[0].blz
    assert_equal "Stadtsparkasse München",  results[0].name
    assert_equal "Stadtsparkasse München",  results[0].short_name
    assert_equal "80791",                   results[0].zip
    assert_equal "München",                 results[0].city
    assert_equal "SSKMDEMMXXX",             results[0].bic
  end

  def test_search_by_exact_match_bremen
    assert results = BLZ::Bank.find_by_blz("29050101", :exact => true)
    assert_equal 2,                   results.size
    assert_equal "29050101",          results[0].blz
    assert_equal "Sparkasse Bremen",  results[0].name
    assert_equal "Spk Bremen",        results[0].short_name
    assert_equal "28078",             results[0].zip
    assert_equal "Bremen",            results[0].city
    assert_equal "SBREDE22XXX",       results[0].bic
  end

  def test_search_by_prefix
    assert results = BLZ::Bank.find_by_blz("7106")
    assert results.size > 1
    #assert_equal "Stadtsparkasse München", results[0].bezeichnung
  end

  def test_search_by_city
    assert results = BLZ::Bank.find_by_city("München")
    assert results.size > 1
    assert results.find { |b| b.blz == "70150000" }
  end

  def test_search_by_bic
    assert results = BLZ::Bank.find_by_bic("SSKMDEMMXXX")
    assert results.size == 1
    assert results.find { |b| b.blz == "70150000" }
  end

  def test_search_by_empty_bic
    assert results = BLZ::Bank.find_by_bic('')
    assert results.size == 0
  end

  def test_search_by_nil_bic
    assert results = BLZ::Bank.find_by_bic(nil)
    assert results.size == 0
  end

  def test_to_s
    assert results = BLZ::Bank.find_by_blz("70150000", :exact_only => true)
    assert_equal 1, results.size
    assert_equal "70150000, Stadtsparkasse München, 80791 München, SSKMDEMMXXX", results[0].to_s
  end

end
