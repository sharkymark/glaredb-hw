SELECT id, name FROM read_postgres(
'postgres://coder:oXRNK5yvzcUl5m3X@localhost:55259/coder', --connection
'public', --schema name
'templates' --table name
);


