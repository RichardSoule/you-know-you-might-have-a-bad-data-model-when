/* Kscope23 
You know you might have a bad data model when...
By Rich Soule
*/


select name as "North America Products"
  from transactional_table
 where substr(product_num,1,2) in ('US','CA','MX');

select phone
     , phone2
     , phone3
     , phone4
  from transactional_table;

select distinct stuff
  from transactional_table;

select count(*) as "Total Referential Constraints"
  from user_constraints
 where constraint_type = 'R';

    with unique_constraints_per_table
      as (select table_name
               , count(*) as number_of_unique_constraints_on_table
            from user_constraints
           where constraint_type in ('P','U') --Primary or Unique
        group by table_name
         )
  select number_of_unique_constraints_on_table 
       , sum(1) as table_count
    from unique_constraints_per_table
group by number_of_unique_constraints_on_table
order by number_of_unique_constraints_on_table desc;

select some_stuff
  from transactional_table
 where remaining_seats != -1
   and …business conditions…;

select some_stuff
  from transactional_table
 where end_date != to_date('9999-12-31','yyyy-mm-dd')
   and …business conditions…;

select a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v
      , w,x,y,z,aa,ab,ac,ad,ae,af,ag,ah,ai,aj,ak,al
      , am,an,ao,ap,aq,ar,as,at,au,av,aw,ax,ay,az,ba
      , bb,bc,bd,be,bf,bg,bh,bi,bj,bk,bl,bm,bn,bo,…
   from transactional_table
  where …business conditions…;

select some_stuff
  from transactional_table
 where active_yn = 'Y'
   and …business conditions…;

select some_stuff
  from transactional_table
 where deleted = 'FALSE'
   and …business conditions…;

select column_value as color
  from table (apex_string.split(
              (select colors
                 from transactional_table
                where user_id = :P1_USER_ID ),':')
             ); 

select t1.stuff
     , t2.things
     , t3.other_stuff
     , t4.other_things
  from transactional_table t1
  join transactional_table t2 using (some_column)
  join transactional_table t3 using (some_other_column)
  join transactional_table t4 using (another_colum)
 where t1.active_yn = 'Y'
   and t2.condition in ('Value1','Value2','etc.')
   and t3.filter between smaller and bigger
   and t4.column is not null;

   select 'Tables' as "Measure"
        , count(*) as "Count"
     from user_tables
union all  
   select 'Materialized Views'
        , count(*)
     from user_mviews;

   select 'Tables' as "Measure"
        , count(*) as "Count"
     from user_tables
union all  
   select 'Indexes'
        , count(*)
     from user_indexes;

    with column_count_by_foreign_key_constraint 
      as (select constraint_name    as foreign_key_constraint
               , count(column_name) as columns_in_foreign_key
            from user_cons_columns
            join user_constraints using (constraint_name)
           where constraint_type = 'R' -- Referential
        group by constraint_name
          having count(column_name) >= 2 -- One is ideal
         )
  select columns_in_foreign_key
       , sum(1) as count_of_foreign_keys
    from column_count_by_foreign_key_constraint
group by columns_in_foreign_key
order by columns_in_foreign_key;

with view_dependencies (name, type, referenced_name, referenced_type, view_depth)
  as ( select name
            , type
            , referenced_name
            , referenced_type
            , 1 as view_depth
         from user_dependencies
        where type = 'VIEW' 
          and referenced_type = 'VIEW'
    union all
       select d.name
            , d.type
            , d.referenced_name
            , d.referenced_type
            , v.view_depth + 1
         from user_dependencies d
         join view_dependencies v on (    d.name = v.referenced_name 
                                      and d.type = 'VIEW' 
                                      and d.referenced_type = 'VIEW')
     )
   , depth_and_name (view_depth, name)
  as (select max(view_depth) as view_depth
           , name
        from view_dependencies
    group by name     
     )
  select view_depth
       , count(*) as total_views
    from depth_and_name 
group by view_depth  
order by view_depth desc;

select key
     , value
 from transactional_table
where …business conditions…;

desc transactional_table