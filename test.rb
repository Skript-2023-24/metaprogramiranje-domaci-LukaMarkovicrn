require "google_drive"
require_relative 'kod'


t = Tabelica.new("1P16n5kgtnzSt2X60xvvwqnyR8RhnDog1jcuH4Yl9OvU", 0)


t.print

t.red(1)
t.each {|red| p red}

p t["Prvakolona"].to_s
p t["Prvakolona"][2]
p t["Prvakolona"][1] = 3
p t["Prvakolona"].to_s

p t.prvakolona.to_s
p t.prvakolona.sum
p t.prvakolona.avg

p t.drugakolona.markovic

p t.prvakolona.map { |cell| cell+=1 }
p t.prvakolona.select { |num|  num.even? }
p t.prvakolona.reduce(1) { |suma, n| suma + n }

