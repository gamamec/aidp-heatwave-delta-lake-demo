# AIDP + MySQL HeatWave – Delta Lake Integration Demo

## Overview

This repository demonstrates how Oracle AIDP Workbench can generate a Delta Lake dataset in OCI Object Storage and how this dataset can be consumed by MySQL HeatWave Lakehouse.

The notebook shows the full lifecycle of a Delta table, including data generation, schema evolution, and append operations.

---

## What the Notebook Does

1. Creates a Spark DataFrame with sample data  
2. Writes the dataset in Delta format to OCI Object Storage  
3. Creates a Delta table referencing that location  
4. Queries the Delta table  
5. Evolves the schema by adding a new column  
6. Appends new records using schema merge  

---

## Delta Lake Features Demonstrated

- Delta file creation  
- Storage in OCI Object Storage  
- Schema enforcement  
- Schema evolution (`mergeSchema=true`)  
- Incremental append  

---

## Storage Location

The Delta table is written to:

```
oci://<bucket>@<namespace>/<folder>/
```

This directory contains:

- `_delta_log/`
- Parquet data files  

---

## Consuming the Delta Table in MySQL HeatWave

After the Delta dataset is generated, it can be consumed in MySQL HeatWave using Lakehouse Auto Parallel Load:

```sql
SET @input_list = '[
  {
    "db_name": "delta_lake_db",
    "tables": [
      {
        "table_name": "delta_table_1",
        "engine_attribute": {
          "dialect": { "format": "delta" },
          "file": [
            { "uri": "oci://<bucket>@<namespace>/<path-to-delta>/" }
          ]
        }
      }
    ]
  }
]';


SET @input_list = '...';
CALL sys.HEATWAVE_LOAD(CAST(@input_list AS JSON), NULL);
```sql

HeatWave automatically infers the schema and enables queries over the Delta Lake dataset without physical ingestion.

---

## Architecture Flow

- AIDP generates and manages the Delta dataset  
- Data is stored in OCI Object Storage  
- MySQL HeatWave Lakehouse reads the Delta table  
- Applications query the data directly from HeatWave  

---

## Author

Erik Gama
