# StringMatching

There is currently no full solution for master data management. Below is a code stub to give you some ideas about how you might go about coming up with a short term solution.

```text
from fuzzywuzzy import fuzz

str1 = 'Bob Wakefield'
str2 = 'bob wakefield'

MatchPercentage = fuzz.token_set_ratio(str1,str2)

print(MatchPercentage)
```

