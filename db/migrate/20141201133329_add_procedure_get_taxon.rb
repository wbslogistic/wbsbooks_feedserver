class AddProcedureGetTaxon < ActiveRecord::Migration
  def change


   sql = <<-SQL

      CREATE FUNCTION get_taxon(child_id integer)
        RETURNS text
        AS
        $$
         WITH RECURSIVE children AS (
        SELECT name,self_id,parent_id, 1 AS depth                  ---|Non
        FROM categories                    --|Recursive
        WHERE  self_id= $1  --1137439  --name = 'Художественная литература'                    ---|Part
        UNION ALL
        SELECT a.name,a.self_id, a.parent_id, depth+1                   ---|Recursive
        FROM categories a                  --|Part
        JOIN children b ON(a.self_id = b.parent_id )    ---|
        )

         select string_agg(name,'>') as name
         from
         (select name  FROM children ORDER BY depth DESC ) as tab1;


        $$
        LANGUAGE SQL IMMUTABLE STRICT;



    SQL

    ActiveRecord::Base.connection.execute  sql

  end
end
