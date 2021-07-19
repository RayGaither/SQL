--You have 2072 plans in your cache, and 19.00% are duplicates with more than 5 entries, meaning similar queries are generating the same plan repeatedly. Forced Parameterization may fix the issue. To find troublemakers, use: 



EXEC sp_BlitzCache @SortOrder = 'query hash';