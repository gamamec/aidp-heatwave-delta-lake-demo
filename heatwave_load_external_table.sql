-- =====================================================================
-- MySQL HeatWave Lakehouse - Delta Lake Auto Parallel Load
-- =====================================================================
-- This script loads a Delta Lake dataset stored in OCI Object Storage
-- into MySQL HeatWave using Lakehouse Auto Parallel Load.
--
-- Requirements:
-- - MySQL HeatWave 9.5+ (9.6 recommended)
-- - Object Storage access configured
-- - Proper IAM policies enabled
-- =====================================================================

-- Update the values below before running

SET @input_list = '[
  {
    "db_name": "delta_lake_db",
    "tables": [
      {
        "table_name": "delta_table_1",
        "engine_attribute": {
          "dialect": { "format": "delta" },
          "file": [
            {
              "uri": "oci://<your-bucket>@<your-namespace>/<path-to-delta>/"
            }
          ]
        }
      }
    ]
  }
]';

-- Execute Lakehouse Auto Parallel Load
CALL sys.HEATWAVE_LOAD(CAST(@input_list AS JSON), NULL);

-- =====================================================================
-- After execution, you can validate with:
--
-- USE delta_lake_db;
-- SELECT * FROM delta_table_1;
-- =====================================================================
