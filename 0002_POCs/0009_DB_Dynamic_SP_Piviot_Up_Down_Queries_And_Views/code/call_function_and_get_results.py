import psycopg2

try:
    conn = psycopg2.connect(dbname="postgres", user="postgres", password="password", host="localhost")
    cur = conn.cursor()

    # First SQL statement
    sql_statement_1 = "SELECT create_and_populate_temp_table('my_temp_data_2','Capability');"
    cur.execute(sql_statement_1)

    # Second SQL statement
    sql_statement_2 = "Select * From my_temp_data_2;"
    cur.execute(sql_statement_2)
    
    column_names = [desc[0] for desc in cur.description]
    
    print(column_names)
    
    rows = cur.fetchall()
    for row in rows:
        print(row)
        
    print("Both SQL statements executed successfully.")

except psycopg2.Error as e:
    print(f"Error: {e}")
finally:
    if cur:
        cur.close()
    if conn:
        conn.close()
