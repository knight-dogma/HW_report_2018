n = gets.chomp.to_i

peak = n

while n > 1 do
  if n % 2 == 0
    n = n / 2
  else
    n = 3 * n + 1
    peak = n if n > peak
  end
end
puts peak
