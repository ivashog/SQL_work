-- Додати атрибут WALK_SPEED для шару доріг highway-line
CASE
WHEN  "HIGHWAY" = 'path' THEN 4
WHEN  "HIGHWAY" = 'track' THEN 4
WHEN  "SURFACE" = 'sett' THEN 4
WHEN  "SURFACE" = 'cobblestone' THEN 4
WHEN  "SURFACE" = 'unpaved' THEN 4
WHEN  "SURFACE" = 'compacted' THEN 4
WHEN  "SURFACE" = 'fine_gravel' THEN 4
WHEN  "SURFACE" = 'gravel' THEN 3
WHEN  "SURFACE" = 'pebblestone' THEN 3
WHEN  "SURFACE" = 'dirt' THEN 3
WHEN  "SURFACE" = 'earth' THEN 3
WHEN  "SURFACE" = 'grass' THEN 3
WHEN  "SURFACE" = 'ground' THEN 3
WHEN  "SURFACE" = 'mud' THEN 3
WHEN  "SURFACE" = 'sand' THEN 3
WHEN  "TUNNEL" = 'yes' THEN 3
WHEN  "HIGHWAY" = 'steps' THEN 1.5
ELSE 5
END