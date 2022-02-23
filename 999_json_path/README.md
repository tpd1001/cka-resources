# JSON PATH

Quiz Solutions - interesting answers

```json
# Q11/13
# literal
$.prizes[5].laureates[2]
# better but overly verbose
$.prizes[?(@.year == "2014")].laureates[?(@.firstname == "Malala")]
# optimal
$.prizes[*].laureates[?(@.firstname == "Malala")]
```
