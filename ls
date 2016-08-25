#! /usr/bin/env ruby


add $files.grep(/\A(Alpha|Beta|Gamma)\.mkdn/).sort

Roman = { 'IV' => 4, 'IX' => 9, 'I' => 1, 'V' => 5, 'XL' => 40, 'X' => 10, 'L' => 50 }
RomanChar = Regexp.new(Roman.keys.to_a.join('|'))
def roman(s)
  s.scan(RomanChar).map(&Roman.method(:[])).reduce(0, &:+)
end

add $files.grep(/\A#{RomanChar}+\.mkdn/).sort {|a, b| roman(a) <=> roman(b) }

Hebrew = { 'Alef' => 1, 'Bet' => 2, 'Gimel' => 3,
           'Dalet' => 4, 'Hei' => 5, 'Vav' => 6,
           'Zayin' => 7, 'Het' => 8, 'Tet' => 9,
           'Yod' => 10, 'Kaf' => 20 }
HebrewChar = Regexp.new(Hebrew.keys.to_a.join('|'))
def hebrew(s)
  s.scan(HebrewChar).map(&Hebrew.method(:[])).reduce(0,&:+)
end

add $files.grep(/\A#{HebrewChar}+\.mkdn/).sort { |a, b| hebrew(a) <=> hebrew(b) }

add $files.grep(/\A[01]+\.mkdn/).sort { |a, b| a.to_i(2) <=> b.to_i(2) }


#####################
#####################
#####################
#####################
#####################
#####################
#####################



BEGIN {
$files = Dir['*.mkdn']
$files.delete_if(&/\A~/.method(:=~))
$filesx = []
def add(x)
  $filesx.concat(x)
end
}

max_len = $filesx.map(&:size).max + 5

$filesx.map!{|a|a.ljust(max_len)}

$filesx = $filesx.each_slice($filesx.size / (79 / max_len)).to_a

$filesx.last.concat([" " * max_len] * ($filesx.first.size - $filesx.last.size))

$filesx = $filesx.transpose

puts $filesx.map(&:join)


