# encoding: utf-8

require 'blz'
require 'test/unit'

class TestBank < Test::Unit::TestCase

  def test_all_banks
    assert !BLZ::Bank.all.nil?
    assert sskm = BLZ::Bank.all.find { |b| b.blz == "70150000" }
    assert_equal "Stadtsparkasse München", sskm.name
  end

  def test_search_by_exact_match
    assert results = BLZ::Bank.find_by_blz("70150000", :exact => true)
    assert_equal 1, results.size
    assert_equal "70150000", results[0].blz
    assert_equal "Stadtsparkasse München", results[0].name
    assert_equal "St Spk München", results[0].short_name
    assert_equal "80791", results[0].zip
    assert_equal "München", results[0].city
    assert_equal "SSKMDEMMXXX", results[0].bic
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
  
  def test_to_s
    assert results = BLZ::Bank.find_by_blz("70150000", :exact_only => true)
    assert_equal 1, results.size
    assert_equal "70150000, Stadtsparkasse München, 80791 München, SSKMDEMMXXX", results[0].to_s
  end

end

