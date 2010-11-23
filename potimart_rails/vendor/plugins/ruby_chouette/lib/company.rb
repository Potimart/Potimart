# id bigint NOT NULL,
# objectid character varying(255),
# objectversion integer,
# creationtime timestamp without time zone,
# creatorid character varying(255),
# name character varying(255),
# shortname character varying(255),
# organisationalunit character varying(255),
# operatingdepartmentname character varying(255),
# code character varying(255),
# phone character varying(255),
# fax character varying(255),
# email character varying(255),
# registrationnumber character varying(255),
# CONSTRAINT company_pkey PRIMARY KEY (id),
# CONSTRAINT company_objectid_key UNIQUE (objectid)


class Company < ChouetteActiveRecord
  set_table_name :company
  # belongs_to :creator, :class_name => "User", :foreign_key => "creatorid"
  has_many :lines, :class_name => "Line", :foreign_key => "companyid"
  
  
end
