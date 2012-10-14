require 'spec_helper'
require 'prawn'

describe PdfHelper do

  let!(:pdf_helper) { PdfHelper.new } 

  describe "wikinize_for_pdf_simple_string" do
    it "nil returns empty string" do
       pdf_helper.wikinize_for_pdf_simple_string(nil).should == ""
    end

    it "empty string returns empty string" do
       pdf_helper.wikinize_for_pdf_simple_string("").should == ""
    end

    it "simple string is wrapped in <p>" do
       pdf_helper.wikinize_for_pdf_simple_string("simple string").should == "simple string"
    end

    it "*word* returns bold" do
       pdf_helper.wikinize_for_pdf_simple_string("simple string with *bold* word").should == "simple string with <b>bold</b> word"
    end

    it "*bold not closed returns *" do
       pdf_helper.wikinize_for_pdf_simple_string("simple string with *bold-not-closed word").should == 
                "simple string with *bold-not-closed word"
    end

    it "more than 1 bold word" do
       pdf_helper.wikinize_for_pdf_simple_string("can we have *more* than *only one* bold word?").should == 
                "can we have <b>more</b> than <b>only one</b> bold word?"
    end

    it "_word_ returns italic" do
       pdf_helper.wikinize_for_pdf_simple_string("simple string with _italic_ word").should == 
                "simple string with <i>italic</i> word"
    end

    it "more than 1 italic word" do
       pdf_helper.wikinize_for_pdf_simple_string("can we have _more_ than _only one_ italic word?").should == 
                "can we have <i>more</i> than <i>only one</i> italic word?"
    end

    it "link is displayed underlined" do
       pdf_helper.wikinize_for_pdf_simple_string("klik hier: http://www.xpday.be").should == 
                "klik hier: <u>http://www.xpday.be</u>"
    end
  end

  describe "wikinize_for_pdf list" do
    it "nil returns empty string" do
       pdf_helper.wikinize_for_pdf_string_with_list(nil).should == ""
    end

    it "empty string returns empty string" do
       pdf_helper.wikinize_for_pdf_string_with_list("").should == ""
    end

    it "* starts ul" do
       pdf_helper.wikinize_for_pdf_string_with_list("* een\n* twee").should == "een\ntwee"
    end
  end

  describe "split_text_in_simple_and_lists" do
    it "nil returns empty array" do
       pdf_helper.split_text_in_simple_and_lists(nil).should == []
    end

    it "empty string returns array with empty string" do
       pdf_helper.split_text_in_simple_and_lists("").should == [""]
    end

    it "simple string returns array with that string" do
       pdf_helper.split_text_in_simple_and_lists("ahaaaaa").should == ["ahaaaaa"]
    end

    it "simple + list returns array with 1 string and 1 list" do
       pdf_helper.split_text_in_simple_and_lists("ahaaaaa\n* list 1\n* list 2").should == ["ahaaaaa\n", "* list 1\n* list 2"]
    end

    it "list returns array with 1 list" do
       pdf_helper.split_text_in_simple_and_lists("* list 1\n* list 2").should == ["* list 1\n* list 2"]
    end

    it "simple + list + simple returns array with 1 string, 1 list and 1 string" do
       pdf_helper.split_text_in_simple_and_lists("ahaaaaa\n* list 1\n* list 2\nooooo").should == ["ahaaaaa\n", "* list 1\n* list 2\n", "ooooo"]
    end

    it "simple + list + simple + list returns array with 1 string, 1 list, 1 string and 1 list" do
       pdf_helper.split_text_in_simple_and_lists("ahaaaaa\n* list 1\n* list 2\nooooo\nkwak kwak\n* nog een list\* joep").should == 
         ["ahaaaaa\n", "* list 1\n* list 2\n", "ooooo\nkwak kwak\n", "* nog een list\* joep"]
    end

  end

end

