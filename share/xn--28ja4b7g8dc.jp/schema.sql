DROP TABLE IF EXISTS redirects;

CREATE TABLE redirects(
    id INTEGER NOT NULL,
    domain VARCHAR(255) NOT NULL,
    origin VARCHAR(255) NOT NULL,
    url VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

CREATE UNIQUE INDEX redirects_domain ON redirects (domain, origin); 
CREATE INDEX redirects_origin ON redirects (origin); 
