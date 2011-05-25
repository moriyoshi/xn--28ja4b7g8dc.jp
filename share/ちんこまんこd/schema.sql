DROP TABLE IF EXISTS records;

CREATE TABLE records(
    id INTEGER NOT NULL,
    `type` VARCHAR(16) NOT NULL,
    domain VARCHAR(255) NOT NULL,
    origin VARCHAR(255) NOT NULL,
    value VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

CREATE UNIQUE INDEX records_domain ON records (domain, origin); 
CREATE INDEX records_origin ON records (origin); 
