# RANGE: sequential series of numbers
# - represented more efficiently than an array of the same numbers
#   - prioritize over array of numbers when possible
# - can act on them somewhat as arrays: (i..j).map { ... }

1..10_000_000 # underscores act as commas for big numbers
(1..100).inject { |acc, e| acc + e } # sums the range of numbers
