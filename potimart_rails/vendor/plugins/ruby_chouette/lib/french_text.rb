# coding: utf-8
# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

module FrenchText
  ACCENT_GROUPS = %w( a|â|à e|ê|è|é|ë i|î|ï o|ô|ö u|û|ù|ü)

  def ignore_accents_pattern(string, splat_before=true)
    target = String.new string
    ACCENT_GROUPS.each do |l|
      target.gsub!( Regexp.new( "[#{l.gsub(/\|/, '')}]"),"(#{l})")
    end
    splat_before ? ".*#{target}.*" : "#{target}.*"
  end
  
    
end
