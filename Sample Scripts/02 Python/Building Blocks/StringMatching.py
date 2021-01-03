from fuzzywuzzy import fuzz

str1 = 'Bob Wakefield'
str2 = 'bob wakefield'

MatchPercentage = fuzz.token_set_ratio(str1,str2)

print(MatchPercentage)