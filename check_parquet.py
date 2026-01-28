import pyarrow.parquet as pq

# Read parquet file
table = pq.read_table('School-Unique-v2.parquet')
df = table.to_pandas()

print("=== School-Unique-v2.parquet ===")
print("\nColumns containing 'Lat' or 'Long':")
lat_long_cols = [col for col in df.columns if 'lat' in col.lower() or 'long' in col.lower()]
print(lat_long_cols)

if lat_long_cols:
    print(f"\nFirst 10 rows with coordinates:")
    print(df[['SchoolID'] + lat_long_cols].head(10))
    print(f"\nNon-null counts:")
    for col in lat_long_cols:
        print(f"{col}: {df[col].notna().sum()}")
