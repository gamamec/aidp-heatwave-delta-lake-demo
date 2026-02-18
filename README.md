# AIDP + MySQL HeatWave – Delta Lake Integration Demo

## Architecture


## Overview

This repository demonstrates how Oracle AIDP Workbench can generate a Delta Lake dataset in OCI Object Storage and how this dataset can be consumed by MySQL HeatWave Lakehouse.

The notebook shows the full lifecycle of a Delta table, including data generation, schema evolution, and append operations.

---

## Architecture Flow

1. AIDP consumes data from multiple sources  
2. The processing layer generates a Delta Lake dataset  
3. The dataset is stored in OCI Object Storage  
4. MySQL HeatWave Lakehouse reads the Delta table  
5. Applications query the data directly from HeatWave  

---

## What the Notebook Demonstrates

- Delta file creation  
- Storage in OCI Object Storage  
- Schema enforcement  
- Schema evolution (`mergeSchema=true`)  
- Incremental append  

---

## Storage Location

The Delta table is written to:

```
oci://<bucket>@<namespace>/<path-to-delta>/
```

This directory contains:

- `_delta_log/`
- Parquet data files  

---

## Prerequisites

- MySQL HeatWave 9.6.0 or later  
- Lakehouse enabled  
- Access to OCI Object Storage  
- IAM policy allowing the DB System to read the bucket  

---

## Consuming the Delta Table in MySQL HeatWave

After the Delta dataset is generated, it can be consumed using Lakehouse Auto Parallel Load:

```sql
SET @input_list = '[
  {
    "db_name": "aidp_delta_demo",
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

CALL sys.HEATWAVE_LOAD(CAST(@input_list AS JSON), NULL);
```

HeatWave Lakehouse automatically infers the schema from the Delta transaction log and enables queries over the dataset without physical ingestion.

---

## Validation

After running the load procedure:

```sql
USE aidp_delta_demo;
SELECT * FROM delta_table_1;
```

---

## Repository Structure

```
README.md
LICENSE
/notebooks/aidp_delta_demo.ipynb
/sql/heatwave_load_external_table.sql
/images/architecture.png (optional)
```

---

## Author

Erik Gama
