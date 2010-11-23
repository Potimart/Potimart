# id bigint NOT NULL,
# objectid character varying(255),
# objectversion integer,
# creationtime timestamp without time zone,
# creatorid character varying(255),
# versiondate date,
# description character varying(255),
# name character varying(255),
# registrationnumber character varying(255),
# sourcename character varying(255),
# sourceidentifier character varying(255),
# "comment" character varying(255),


class PTNetwork < ChouetteActiveRecord
  set_table_name :ptnetwork
  has_many :lines, :class_name => "Line", :foreign_key => "ptnetworkid"
  
end
