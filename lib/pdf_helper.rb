require 'prawn'

class PdfHelper
  def self.wikinize_for_pdf( text )
    return "" unless text and not text.empty?
    if text =~ /^\* /  #list
      text = text.gsub(/^\* (.*)/, "#{Prawn::Text::NBSP * 3}\u2022 \\1")
    end
    text = text.gsub( /\*([^*\n]*)\*/, '<b>\1</b>' ) #bold
    text = text.gsub( /_([^_\n]*)_/, '<i>\1</i>' )   #italic
    text = text.gsub(/(http:\/\/[^ ]*)/, '<u>\1</u>') #links
  end
end 
