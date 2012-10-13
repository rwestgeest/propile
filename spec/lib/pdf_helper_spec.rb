require 'spec_helper'

describe PdfHelper do

  describe "wikinize_for_pdf" do
    it "nil returns empty string" do
       PdfHelper.wikinize_for_pdf(nil).should == ""
    end

    it "empty string returns empty string" do
       PdfHelper.wikinize_for_pdf("").should == ""
    end

    it "simple string is wrapped in <p>" do
       PdfHelper.wikinize_for_pdf("simple string").should == "simple string"
    end

    it "*word* returns bold" do
       PdfHelper.wikinize_for_pdf("simple string with *bold* word").should == "simple string with <b>bold</b> word"
    end

    it "*bold not closed returns *" do
       PdfHelper.wikinize_for_pdf("simple string with *bold-not-closed word").should == 
                "simple string with *bold-not-closed word"
    end

    it "more than 1 bold word" do
       PdfHelper.wikinize_for_pdf("can we have *more* than *only one* bold word?").should == 
                "can we have <b>more</b> than <b>only one</b> bold word?"
    end

    it "_word_ returns italic" do
       PdfHelper.wikinize_for_pdf("simple string with _italic_ word").should == 
                "simple string with <i>italic</i> word"
    end

    it "more than 1 italic word" do
       PdfHelper.wikinize_for_pdf("can we have _more_ than _only one_ italic word?").should == 
                "can we have <i>more</i> than <i>only one</i> italic word?"
    end

    it "link is displayed underlined" do
       PdfHelper.wikinize_for_pdf("klik hier: http://www.xpday.be").should == 
                "klik hier: <u>http://www.xpday.be</u>"
    end
  end

  describe "wikinize_for_pdf list" do
    it "* starts ul" do
       PdfHelper.wikinize_for_pdf("* een\n* twee").should == 
                "#{Prawn::Text::NBSP * 3}\u2022 een\n#{Prawn::Text::NBSP * 3}\u2022 twee"
    end

    it "ul with string before" do
       PdfHelper.wikinize_for_pdf("voila:\n* een\n* twee").should == 
                "voila:\n#{Prawn::Text::NBSP * 3}\u2022 een\n#{Prawn::Text::NBSP * 3}\u2022 twee"
    end

    it "ul with string after" do
       PdfHelper.wikinize_for_pdf("* een\n* twee\nen nog iets").should == 
                "#{Prawn::Text::NBSP * 3}\u2022 een\n#{Prawn::Text::NBSP * 3}\u2022 twee\nen nog iets"
    end

    it "2 uls in a string" do
       PdfHelper.wikinize_for_pdf("* een\n* twee\nblabla\n* nog \n* en nog").should == 
                "#{Prawn::Text::NBSP * 3}\u2022 een\n#{Prawn::Text::NBSP * 3}\u2022 twee\nblabla\n#{Prawn::Text::NBSP * 3}\u2022 nog \n#{Prawn::Text::NBSP * 3}\u2022 en nog"
    end
  end

end

