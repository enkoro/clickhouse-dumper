#!/bin/bash

# Clickhouse host
if [ -z "$CH_HOST" ]; then
    echo "Clickhouse host not set."
    exit 1
fi

# Clickhouse port
if [ -z "$CH_PORT" ]; then
    CH_PORT=9000
fi

# Clickhouse user
if [ -z "$CH_USER" ]; then
    CH_USER=default
fi

# Clickhouse password
if [ -z "$CH_PASSWORD" ]; then
    CH_PASSWORD=""
fi

# Dump output directory
if [ -z "$CH_DUMP_OUTDIR" ]; then
    CH_DUMP_OUTDIR=./dump
fi
mkdir -p "$CH_DUMP_OUTDIR"

# If CH_DB not set, run through all DBs
if [ -z "$CH_DB" ]; then
    CH_DB=$(clickhouse client --host "$CH_HOST" --port "$CH_PORT" --user "$CH_USER" --password "$CH_PASSWORD" --query "SHOW DATABASES")
fi

while read -r db; do
    while read -r table; do

        if [ "$db" == "system" ]; then
            echo "skip system db"
            continue 2
        fi

        if [[ $table == ".inner."* ]]; then
            echo "skip materialized view $table ($db)"
            continue
        fi

        echo "export table $table from database $db"

        # dump schema
        clickhouse client --host "$CH_HOST" --port "$CH_PORT" --user "$CH_USER" --password "$CH_PASSWORD" --query "SHOW CREATE TABLE ${db}.${table}" >"${CH_DUMP_OUTDIR}/${db}_${table}_schema.sql"

        # dump data
        if [ "$CH_DUMP_DATA" ]; then
            clickhouse client --host "$CH_HOST" --port "$CH_PORT" --user "$CH_USER" --password "$CH_PASSWORD" --format TabSeparated --query "SELECT * FROM ${db}.${table}" | pigz >"${CH_DUMP_OUTDIR}/${db}_${table}_data.tsv.gz"
        fi

    done < <(clickhouse client --host "$CH_HOST" --port "$CH_PORT" --user "$CH_USER" --password "$CH_PASSWORD" --query "SHOW TABLES FROM $db")
done < <(echo "$CH_DB")
