require 'spec_helper'
require 'prawn'

describe PdfHelper do
  include PdfHelper

  describe "wikinize_for_pdf_simple_string" do
    it "nil returns empty string" do
       wikinize_for_pdf_simple_string(nil).should == ""
    end

    it "empty string returns empty string" do
       wikinize_for_pdf_simple_string("").should == ""
    end

    it "simple string remains simple string" do
       wikinize_for_pdf_simple_string("simple string").should == "simple string"
    end

    it "new-line remains new-line"  do
      wikinize_for_pdf_simple_string("string\nwith newline").should == "string\nwith newline"
    end

    it "*word* returns bold" do
       wikinize_for_pdf_simple_string("simple string with *bold* word").should == "simple string with <b>bold</b> word"
    end

    it "*bold not closed returns *" do
       wikinize_for_pdf_simple_string("simple string with *bold-not-closed word").should == 
                "simple string with *bold-not-closed word"
    end

    it "more than 1 bold word" do
       wikinize_for_pdf_simple_string("can we have *more* than *only one* bold word?").should == 
                "can we have <b>more</b> than <b>only one</b> bold word?"
    end

    it "_word_ returns italic" do
       wikinize_for_pdf_simple_string("simple string with _italic_ word").should == 
                "simple string with <i>italic</i> word"
    end

    it "more than 1 italic word" do
       wikinize_for_pdf_simple_string("can we have _more_ than _only one_ italic word?").should == 
                "can we have <i>more</i> than <i>only one</i> italic word?"
    end
  end

  describe "wikinize links" do
    it "link is displayed underlined" do
       wikinize_for_pdf_simple_string("klik hier: http://www.xpday.be").should == 
                "klik hier: <u>http://www.xpday.be</u>"
    end

    it "link in begining of line is displayed underlined" do
       wikinize_for_pdf_simple_string("http://www.xpday.be").should == 
                "<u>http://www.xpday.be</u>"
    end

    it "link ending by blank is displayed in a clickable way"  do
      wikinize_for_pdf_simple_string("klik hier: http://www.xpday.be ").should ==
        "klik hier: <u>http://www.xpday.be</u> "
    end

    it "link ending by special char is displayed in a clickable way"  do
      wikinize_for_pdf_simple_string("xpday (http://www.xpday.be) ").should ==
        "xpday (<u>http://www.xpday.be</u>) "
    end

    it "link containing / is displayed in a clickable way"  do
      wikinize_for_pdf_simple_string("xpday (http://www.xpday.be/frontpage ").should ==
        "xpday (<u>http://www.xpday.be/frontpage</u> "
    end

    it "link with name is displayed in a clickable way"  do
      wikinize_for_pdf_simple_string("bla [[http://www.xpday.be HOI]]").should ==
        "bla <u>http://www.xpday.be</u> (HOI)"
    end

    it "two links on one line are displayed in a clickable way"  do
      wikinize_for_pdf_simple_string("bla [[http://www.xpday.be HOI]] and [[http://www.atbru.be Agile Tour Brussels]] also").should ==
        "bla <u>http://www.xpday.be</u> (HOI) and <u>http://www.atbru.be</u> (Agile Tour Brussels) also"
    end
    
    it "accepts secure https URLs" do
      wikinize_for_pdf_simple_string("klik hier: https://github.com/rwestgeest/propile").should ==
        "klik hier: <u>https://github.com/rwestgeest/propile</u>"
    end

    it "accepts named secure https URLs" do
      wikinize_for_pdf_simple_string("klik hier: [[https://github.com/rwestgeest/propile Our project]]").should ==
        "klik hier: <u>https://github.com/rwestgeest/propile</u> (Our project)"
    end

    it "accepts URLs with an underscore" do
      wikinize_for_pdf_simple_string("klik hier: http://github.com/rwestgeest/propile_Our").should ==
        "klik hier: <u>http://github.com/rwestgeest/propile_Our</u>"
    end

    it "accepts URLs with 2 underscores" do
      wikinize_for_pdf_simple_string("klik hier: http://github.com/rwestgeest/propile_Our_Project").should ==
        "klik hier: <u>http://github.com/rwestgeest/propile_Our_Project</u>"
    end

    it "accepts URLs with an underscore in braces" do
      wikinize_for_pdf_simple_string("klik hier: [[http://github.com/rwestgeest/propile_Our project]]").should ==
        "klik hier: <u>http://github.com/rwestgeest/propile_Our</u> (project)"
    end

    it "accepts URLs with 2 underscores in braces" do
      wikinize_for_pdf_simple_string("klik hier: [[http://github_2.com/rwestgeest/propile_Our project]]").should ==
        "klik hier: <u>http://github_2.com/rwestgeest/propile_Our</u> (project)"
    end
  end

  describe "split_list_string" do
    it "bulleted list returns array with the list items" do
       split_list_string("* een\n* twee").should == ["een", "twee"]
    end

    it "bulleted list with ending eol returns array with the list items" do
       split_list_string("* een\n* twee\n").should == ["een", "twee"]
    end
  end

  describe "split_text_in_simple_and_lists" do
    it "nil returns empty array" do
       split_text_in_simple_and_lists(nil).should == []
    end

    it "empty string returns array with empty string" do
       split_text_in_simple_and_lists("").should == [""]
    end

    it "simple string returns array with that string" do
       split_text_in_simple_and_lists("ahaaaaa").should == ["ahaaaaa"]
    end

    it "simple + list returns array with 1 string and 1 list" do
       split_text_in_simple_and_lists("ahaaaaa\n* list 1\n* list 2").should == ["ahaaaaa\n", "* list 1\n* list 2"]
    end

    it "list returns array with 1 list" do
       split_text_in_simple_and_lists("* list 1\n* list 2").should == ["* list 1\n* list 2"]
    end

    it "simple + list + simple returns array with 1 string, 1 list and 1 string" do
       split_text_in_simple_and_lists("ahaaaaa\n* list 1\n* list 2\nooooo").should == ["ahaaaaa\n", "* list 1\n* list 2\n", "ooooo"]
    end

    it "simple + list + simple + list returns array with 1 string, 1 list, 1 string and 1 list" do
       split_text_in_simple_and_lists("ahaaaaa\n* list 1\n* list 2\nooooo\nkwak kwak\n* nog een list\* joep").should == 
         ["ahaaaaa\n", "* list 1\n* list 2\n", "ooooo\nkwak kwak\n", "* nog een list\* joep"]
    end

  end

end

