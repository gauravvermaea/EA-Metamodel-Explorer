CREATE EXTENSION IF NOT EXISTS tablefunc;

--Entity_Types
Create Table Entity_Types
(
	Id Integer Primary Key,
	EntityTypeName Text
);

--Entity_Attribute_Types
Create Table Entity_Attribute_Types
(
	Id Integer Primary Key,
	Entity_Type_Id Integer,
	Attribute_Name Text,
	Data_Type Text
);

--Entities
Create Table Entities
(
	Id Integer Primary Key,
	Entity_Type_Id Integer,
	Entity_Name Text
);

--Attributes
Create Table Attributes
(
	Id Integer Primary Key,
	Entity_Id Integer,
	Entity_Attribute_Id Integer,
	Attribute_Value Text
);

Insert Into Entity_Types Values(1,'Capability');
Insert Into Entity_Types Values(2,'Applications');
--Select * From Entity_Types;

Insert Into Entity_Attribute_Types Values(1,1,'Name','Text');
Insert Into Entity_Attribute_Types Values(2,1,'Description','Text');
Insert Into Entity_Attribute_Types Values(3,2,'Name','Text');
Insert Into Entity_Attribute_Types Values(4,2,'Description','Text');
Insert Into Entity_Attribute_Types Values(5,2,'Owner','Text');

Insert Into Entities Values(1,1,'Finance');
Insert Into Entities Values(2,1,'Assets');
Insert Into Entities Values(3,2,'GL');
Insert Into Entities Values(4,2,'Finance_Reports');
Insert Into Entities Values(5,2,'Building_Management');
Insert Into Entities Values(6,2,'Wharehouse');

Insert Into Attributes Values(1,1,1,'Finance Capability');
Insert Into Attributes Values(2,1,2,'Finance Capability Description');
Insert Into Attributes Values(3,2,1,'Asset Capability');
Insert Into Attributes Values(4,2,2,'Asset Capability Description');
Insert Into Attributes Values(5,3,3,'GL Application');
Insert Into Attributes Values(6,3,4,'GL Description');
Insert Into Attributes Values(7,3,5,'GL Owner');
Insert Into Attributes Values(8,5,3,'Building_Management Application');
Insert Into Attributes Values(9,5,4,'Building_Management Description');
Insert Into Attributes Values(10,5,5,'Building_Management Owner');
Insert Into Attributes Values(11,6,3,'Warehouse Application');
Insert Into Attributes Values(12,6,4,'Warehouse Description');
Insert Into Attributes Values(13,6,5,'Warehouse Owner');
Insert Into Attributes Values(14,4,3,'Fin Report Application');
Insert Into Attributes Values(15,4,4,'Fin Report Description');
Insert Into Attributes Values(16,4,5,'Fin Report Owner');


Create Table Relationship_Types(
  Id Integer Primary Key,
  Entity1_Type Integer,
  Entity2_Type Integer,
  Relationship_Name Text
);

Insert Into Relationship_Types values (1,1,2,'Capability_Realised_By_Application');

Create Table Relationships(
Id Integer Primary Key,
Relationship_Type_Id Integer,
Entity1 Integer,
Entity2 Integer
);

Insert Into Relationships Values(1,1,1,3);
Insert Into Relationships Values(2,1,1,4);
Insert Into Relationships Values(3,1,2,5);
Insert Into Relationships Values(4,1,2,6);




Create Temporary Table EA_Entities
(
  Id Serial Primary Key,
  entitytypename Text,
  entity_name Text,
  attribute_name Text,
  attribute_value Text
);

Insert Into EA_Entities (entitytypename,entity_name,attribute_name,attribute_value)
Select entitytypename, entity_name     ,attribute_name   ,attribute_value         
From Entity_Types, Entity_Attribute_Types, Entities, Attributes 
Where Entity_Types.Id  = Entity_Attribute_Types.Entity_Type_Id
and Entities.Entity_Type_Id = Entity_Types.Id
and Attributes.Entity_Id = Entities.Id
and Attributes.Entity_Attribute_Id = Entity_Attribute_Types.Id;


CREATE OR REPLACE FUNCTION create_and_populate_temp_table(table_name TEXT, query_string TEXT)
RETURNS VOID
LANGUAGE plpgsql AS $$
BEGIN
    EXECUTE format('CREATE TEMPORARY TABLE %I AS %s', table_name, query_string);
END;
$$;

SELECT create_and_populate_temp_table('my_temp_data_1', 'SELECT distinct attribute_name FROM EA_Entities');

Select * From my_temp_data_1;

Select * From EA_Entities;

DO $$
DECLARE
    col_list TEXT;
    sql_stmt TEXT;
    new_stmnt TEXT;
BEGIN
    -- Get comma-separated column names (quoted properly)
    SELECT  string_agg(quote_ident(attribute_name) || ' TEXT', ', ')
    INTO col_list
    FROM my_temp_data_1;

    -- Build CREATE TABLE statement
    sql_stmt := 'CREATE TEMPORARY TABLE my_table (entitytypename TEXT, entity_name   text, '  || col_list || ');';
    
    raise notice '%',sql_stmt;
    new_stmnt :=  Replace(sql_stmt, '"','');
    raise notice '%',new_stmnt;
    -- Execute it
    EXECUTE new_stmnt;
END$$;


Insert Into my_table(entitytypename , entity_name )
Select distinct entitytypename, entity_name from EA_Entities;


Select * From my_table;    


DO $$
DECLARE
    rec EA_Entities%ROWTYPE;  -- declare a variable to hold each row
    sql_stmnt TEXT;
BEGIN
    -- Loop through all records in EA_Entities
    FOR rec IN SELECT * FROM EA_Entities
    LOOP
        -- Example: print each record
        --RAISE NOTICE 'Id: %, Type: %, Name: %, Attribute: %, Value: %',
        --             rec.Id, rec.entitytypename, rec.entity_name, rec.attribute_name, rec.attribute_value;
        
        
        sql_stmnt:= 'Update my_table Set '|| rec.attribute_name || ' = ''' || rec.attribute_value || ''' where entitytypename =   '''||rec.entitytypename || ''' and entity_name = '''|| rec.entity_name || ''' ;' ;
        -- You can also perform other operations here, e.g., insert, update, etc.
        --RAISE NOTICE '% ', sql_stmnt;
        EXECUTE sql_stmnt;
    END LOOP;
END
$$;


Select * From my_table;