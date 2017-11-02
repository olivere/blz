# encoding: utf-8

require 'blz'
require 'test/unit'
require 'stringio'

class TestBank < Test::Unit::TestCase
  DATA_FILES = Dir[File.join(File.dirname(__FILE__), '../data/*.tsv.gz')].sort

  DATA_FILES.each do |filename|
    define_method "test_find_file_for_#{File.basename(filename)[0..-8]}" do
      assert_stderr_no_match "The data provided may not be accurate" do
        date = BLZ.convert_file_to_date(filename)
        file = BLZ.find_data_file(date)
        assert_equal b(filename), b(file)
      end
    end
  end

  def test_find_file_for_past_date
    assert_stderr_match "The data provided may not be accurate" do
      file  = DATA_FILES.first
      date  = BLZ.convert_file_to_date(file) - 1
      found = BLZ.find_data_file(date)
      assert_equal b(file), b(found)
    end
  end

  def test_find_file_for_future_date
    assert_stderr_match "The data provided may not be accurate" do
      file  = DATA_FILES.last
      date  = BLZ.convert_file_to_date(file) + 91
      found = BLZ.find_data_file(date)
      assert_equal b(file), b(found)
    end
  end

  def test_current_data_file
    re = /\A\d{4}_\d\d_\d\d\.tsv\.gz\z/
    assert_match re, File.basename(BLZ::DATA_FILE)
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

  # helper

  def assert_stderr_match(msg, &block)
    serr = redirect_stderr(&block)
    assert_match msg, serr
  end

  def assert_stderr_no_match(msg, &block)
    msg = Regexp.new(Regexp.escape(msg)) unless msg.is_a?(Regexp)
    serr = redirect_stderr(&block)
    assert_no_match msg, serr
  end

  def b(file)
    File.basename file
  end

  def redirect_stderr
    fake_stderr = StringIO.new
    original_stderr, $stderr = $stderr, fake_stderr
    yield
    fake_stderr.string
  ensure
    $stderr = original_stderr
  end
end
