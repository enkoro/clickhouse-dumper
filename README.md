# Clickhouse schema dump script

## Env variables

| $CH_HOST        | Clickhouse host.                                                            |
| --------------- | --------------------------------------------------------------------------- |
| $CH_PORT        | Clickhouse port.                                                            |
| $CH_USER        | Clickhouse user.                                                            |
| $CH_PASSWORD    | Clickhouse password.                                                        |
| $CH_DUMP_OUTDIR | Dump output directory inside a container.                                   |
| $CH_DB          | If CH_DB not set, run through all DBs.                                      |
| $CH_DUMP_DATA   | Boolean flag to dump data. If false or not set, only schema will be dumped. |

## Usage

1. Build a container

   ```bash
   docker build --tag chdumper .
   ```

2. Mount local directory (for dump files) and login inside a container

   ```bash
   docker run --rm -it --env CH_HOST=192.168.1.141 --env CH_DUMP_DATA=true --env CH_DUMP_OUTDIR=/dump -v ./dump:/dump chdumper bash
   ```

3. Run _dump.sh_. Output files will be inside local _./dump_ folder

   ```bash
   ./dump.sh
   ```
