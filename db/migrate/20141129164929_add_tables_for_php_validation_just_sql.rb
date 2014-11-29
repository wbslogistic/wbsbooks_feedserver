class AddTablesForPhpValidationJustSql < ActiveRecord::Migration


  def change
    sql_create_auhors = <<-SQL

          CREATE TABLE authors
          (
            authorid bigserial NOT NULL,
            authorru character varying(45),
            authoren character varying(45),
            international boolean,
            confirmed numeric(3,0),
            confirmedby character varying(45),
            dateconfirmed timestamp without time zone,
            duplicateof bigint,
            bookinfo integer NOT NULL DEFAULT 0,
            bookinfo_en integer NOT NULL DEFAULT 0,
            bookinfo_ru integer NOT NULL DEFAULT 0,
            CONSTRAINT pk_authors PRIMARY KEY (authorid)
          )
          WITH (
            OIDS=FALSE
          );
          ALTER TABLE authors
            OWNER TO postgres;


          CREATE INDEX authors_conf
            ON authors
            USING btree
            (confirmed);


          CREATE INDEX authors_idx_authorru
            ON authors
            USING btree
            (authorru COLLATE pg_catalog."default");


          CREATE INDEX authors_search
            ON authors
            USING btree
            (authorru COLLATE pg_catalog."default");
    SQL

    sql_create_book_isbn= <<-SQL


            CREATE TABLE bookisbns
            (
              bookisbnid bigserial NOT NULL,
              bookid bigint,
              isbn character varying(150),
              source character varying(45),
              confirmed boolean NOT NULL DEFAULT true,
              CONSTRAINT pk_bookisbns PRIMARY KEY (bookisbnid)
            )
            WITH (
              OIDS=FALSE
            );
            ALTER TABLE bookisbns
              OWNER TO postgres;


            CREATE INDEX bookisbns_idx_book
              ON bookisbns
              USING btree
              (bookid);

            CREATE INDEX bookisbns_idx_bookisbn
              ON bookisbns
              USING btree
              (bookid, isbn COLLATE pg_catalog."default");

            CREATE INDEX bookisbns_idx_isbn
              ON bookisbns
              USING btree
              (isbn COLLATE pg_catalog."default");


    SQL


    create_book_lock =<<-SQL


        CREATE TABLE booklock
        (
          idbooklock serial NOT NULL,
          bookid bigint NOT NULL,
          userid integer NOT NULL,
          CONSTRAINT pk_booklock PRIMARY KEY (idbooklock)
        )
        WITH (
          OIDS=FALSE
        );
        ALTER TABLE booklock
          OWNER TO postgres;


    SQL


    create_book_bookpublishers = <<-SQL

              CREATE TABLE bookpublishers
          (
            idvalidation_books_publishers serial NOT NULL,
            bookid bigint NOT NULL,
            publisherid bigint NOT NULL,
            CONSTRAINT pk_bookpublishers PRIMARY KEY (idvalidation_books_publishers)
          )
          WITH (
            OIDS=FALSE
          );
          ALTER TABLE bookpublishers
            OWNER TO postgres;


          CREATE INDEX bookpublishers_idxbookid
            ON bookpublishers
            USING btree
            (bookid);
    SQL


    create_book_translation = <<-SQL

          CREATE TABLE booktranslations
          (
            booktranslationid bigserial NOT NULL,
            bookid bigint NOT NULL,
            titleen text,
            descriptionen text,
            dateconfirmed timestamp without time zone,
            datelasteffective timestamp without time zone,
            confirmedby character varying(45),
            synccode integer,
            weight integer,
            CONSTRAINT pk_booktranslations PRIMARY KEY (booktranslationid)
          )
          WITH (
            OIDS=FALSE
          );
          ALTER TABLE booktranslations
            OWNER TO postgres;

          CREATE UNIQUE INDEX booktranslations_booktranslationid_unique
            ON booktranslations
            USING btree
            (booktranslationid);


          CREATE INDEX booktranslations_idbookid
            ON booktranslations
            USING btree
            (bookid);


          CREATE INDEX booktranslations_idx1
            ON booktranslations
            USING btree
            (datelasteffective);

          CREATE INDEX booktranslations_idxbookid
            ON booktranslations
            USING btree
            (bookid);

          -- Index: booktranslations_idxlasteffective

          -- DROP INDEX booktranslations_idxlasteffective;

          CREATE INDEX booktranslations_idxlasteffective
            ON booktranslations
            USING btree
            (datelasteffective);


    SQL

  publisher_list_sql=  <<-SQL


        CREATE TABLE publisherlist
        (
          publisherid serial NOT NULL,
          publishernameru character varying(150),
          publishernameen character varying(150),
          CONSTRAINT pk_publisherlist PRIMARY KEY (publisherid)
        )
        WITH (
          OIDS=FALSE
        );
        ALTER TABLE publisherlist
          OWNER TO postgres;

        CREATE INDEX publisherlist_idx1
          ON publisherlist
          USING btree
          (publishernameen COLLATE pg_catalog."default");



    SQL



    publisher_list_isbn_sql = <<-SQL
              CREATE TABLE publisherlistisbn
              (
                publisherlistisbnid serial NOT NULL,
                publisherid integer NOT NULL,
                isbn10 character varying(45),
                isbn13 character varying(45),
                CONSTRAINT pk_publisherlistisbn PRIMARY KEY (publisherlistisbnid)
              )
              WITH (
                OIDS=FALSE
              );
              ALTER TABLE publisherlistisbn
                OWNER TO postgres;

              CREATE UNIQUE INDEX publisherlistisbn_idx_isbn
                ON publisherlistisbn
                USING btree
                (isbn10 COLLATE pg_catalog."default");


              CREATE INDEX publisherlistisbn_publisherid_idx
                ON publisherlistisbn
                USING btree
                (publisherid);

              CREATE UNIQUE INDEX publisherlistisbnid_unique
                ON publisherlistisbn
                USING btree
                (publisherlistisbnid);
    SQL


    suggestedtitleslist_sql =  <<-SQL

          CREATE TABLE suggestedtitleslist
          (
            idsuggestedtitles serial NOT NULL,
            listname character varying(95),
            publish integer DEFAULT 0,
            CONSTRAINT pk_suggestedtitleslist PRIMARY KEY (idsuggestedtitles)
          )
          WITH (
            OIDS=FALSE
          );
          ALTER TABLE suggestedtitleslist
            OWNER TO postgres;




    SQL



    suggestedtitleslistitems_sql =  <<-SQL


          CREATE TABLE suggestedtitleslistitems
          (
            idsuggestedtitleslistitems bigserial NOT NULL,
            idsuggestedtitleslistperiod bigint,
            barcode character varying(45),
            bookid bigint,
            CONSTRAINT pk_suggestedtitleslistitems PRIMARY KEY (idsuggestedtitleslistitems)
          )
          WITH (
            OIDS=FALSE
          );
          ALTER TABLE suggestedtitleslistitems
            OWNER TO postgres;


          CREATE INDEX suggestedtitleslistitems_idx_bookid
            ON suggestedtitleslistitems
            USING btree
            (bookid);


    SQL

    suggestedtitleslist_period_sql = <<-SQL


        CREATE TABLE suggestedtitleslistperiod
        (
          idnewlist serial NOT NULL,
          idsuggestedtitles integer,
          month integer,
          year integer,
          tmpid integer,
          publish integer,
          CONSTRAINT pk_suggestedtitleslistperiod PRIMARY KEY (idnewlist)
        )
        WITH (
          OIDS=FALSE
        );
        ALTER TABLE suggestedtitleslistperiod
          OWNER TO postgres;

    SQL


    users_sql=  <<-SQL

          CREATE TABLE users
          (
            userid serial NOT NULL,
            username character varying(50) NOT NULL,
            password character varying(50) NOT NULL,
            addpublisher numeric(3,0) NOT NULL DEFAULT 0,
            runstats numeric(3,0) NOT NULL DEFAULT 0,
            agency numeric(3,0) NOT NULL DEFAULT 0,
            active numeric(3,0) NOT NULL DEFAULT 0,
            CONSTRAINT pk_users PRIMARY KEY (userid)
          )
          WITH (
            OIDS=FALSE
          );
          ALTER TABLE users
            OWNER TO postgres;


          CREATE UNIQUE INDEX users_username
            ON users
            USING btree
            (username COLLATE pg_catalog."default");
    SQL



    usersessions_sql=  <<-SQL
        CREATE TABLE usersessions
        (
          userhistoryid serial NOT NULL,
          userid integer,
          username character varying(50),
          logindate timestamp without time zone,
          logoffdate timestamp without time zone,
          lastactivity timestamp without time zone,
          sessionid character varying(32),
          CONSTRAINT pk_usersessions PRIMARY KEY (userhistoryid)
        )
        WITH (
          OIDS=FALSE
        );
        ALTER TABLE usersessions
          OWNER TO postgres;


    SQL



    userviews_sql = <<-SQL
        CREATE TABLE userviews
        (
          userviewsid bigserial NOT NULL,
          userid integer NOT NULL,
          sessionid character varying(45) NOT NULL,
          bookid bigint NOT NULL,
          dateviewed timestamp without time zone,
          validated integer DEFAULT 0,
          CONSTRAINT pk_userviews PRIMARY KEY (userviewsid)
        )
        WITH (
          OIDS=FALSE
        );
        ALTER TABLE userviews
          OWNER TO postgres;
    SQL

    ActiveRecord::Base.connection.execute  sql_create_auhors
    ActiveRecord::Base.connection.execute sql_create_book_isbn
    ActiveRecord::Base.connection.execute create_book_lock
    ActiveRecord::Base.connection.execute create_book_bookpublishers
    ActiveRecord::Base.connection.execute create_book_translation
    ActiveRecord::Base.connection.execute publisher_list_sql
    ActiveRecord::Base.connection.execute publisher_list_isbn_sql
    ActiveRecord::Base.connection.execute suggestedtitleslist_sql
    ActiveRecord::Base.connection.execute suggestedtitleslistitems_sql
    ActiveRecord::Base.connection.execute suggestedtitleslist_period_sql
    ActiveRecord::Base.connection.execute users_sql
    ActiveRecord::Base.connection.execute usersessions_sql
    ActiveRecord::Base.connection.execute userviews_sql


  end
end






