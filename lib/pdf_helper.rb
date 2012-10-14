require 'prawn'

class PdfHelper

  CONTAINS_LIST_PATTERN = /^\* .*/m
  CONTAINS_NON_LIST_PATTERN = /^[^\*].*/m 

  def wikinize_for_pdf(description, pdf)
    split_text_in_simple_and_lists(description).each { |simple_or_list| 
      if simple_or_list =~ CONTAINS_LIST_PATTERN
        pdf.bounding_box( [30, pdf.cursor], :width => 520 )  do 
          pdf.text wikinize_for_pdf_string_with_list(simple_or_list), :align => :justify, :inline_format => true 
        end
      else
        pdf.text wikinize_for_pdf_simple_string(simple_or_list), :align => :justify, :inline_format => true 
      end
    }
  end

  def split_text_in_simple_and_lists(text)
    result = []
    while !text.nil? && text =~ CONTAINS_LIST_PATTERN   #list found
      result << $` if not $`.empty? #non-list part before list
      text = $&  #remainder
      text =~ CONTAINS_NON_LIST_PATTERN #non-list found (or not) in remainder
      result << ($` || text) #this is the list part
      text = $&   #remainder (possibly nil)
    end
    result << text unless text.nil? 
    result
  end

  def wikinize_for_pdf_simple_string( text )
    return "" unless text and not text.empty?
    text = text.gsub( /\*([^*\n]*)\*/, '<b>\1</b>' ) #bold
    text = text.gsub( /_([^_\n]*)_/, '<i>\1</i>' )   #italic
    text = text.gsub(/(http:\/\/[^ ]*)/, '<u>\1</u>') #links
  end

  def wikinize_for_pdf_string_with_list( text )
    return "" unless text and not text.empty?
    if text =~ /^\* /  #list
      text = text.gsub(/^\* (.*)/, "\u2022 \\1")
    end
  end

end 
